data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_id" "id" {
  byte_length = 8
}

resource "random_id" "auth_token" {
  byte_length = 32
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.cluster_name]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

resource "aws_security_group" "ec" {
  name        = "cp-${random_id.id.hex}"
  description = "Allow inbound traffic from kubernetes private subnets"
  vpc_id      = data.aws_vpc.selected.id

  // We cannot use `${aws_db_instance.rds.port}` here because it creates a
  // cyclic dependency. Rather than resorting to `aws_security_group_rule` which
  // is not ideal for managing rules, we will simply allow traffic to all ports.
  // This does not compromise security as the instance only listens on one port.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
  }
}

resource "aws_elasticache_replication_group" "ec_redis" {
  automatic_failover_enabled = true
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    var.number_cache_clusters,
  )
  replication_group_id          = "cp-${random_id.id.hex}"
  replication_group_description = "team=${var.team_name} / app=${var.application} / env=${var.environment-name}"
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  number_cache_clusters         = var.number_cache_clusters
  parameter_group_name          = var.parameter_group_name
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.ec_subnet.name
  security_group_ids            = [aws_security_group.ec.id]
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = random_id.auth_token.hex
  apply_immediately             = true
  maintenance_window            = var.maintenance_window

  tags = {
    namespace              = var.namespace
    business-unit          = var.business-unit
    application            = var.application
    is-production          = var.is-production
    environment-name       = var.environment-name
    owner                  = var.team_name
    infrastructure-support = var.infrastructure-support
  }
}

resource "aws_elasticache_subnet_group" "ec_subnet" {
  name       = "ec-sg-${random_id.id.hex}"
  subnet_ids = data.aws_subnet_ids.private.ids
}
