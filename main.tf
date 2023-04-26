locals {
  default_tags = {
    # Mandatory
    business-unit = var.business-unit
    application   = var.application
    is-production = var.is-production
    owner         = var.team_name
    namespace     = var.namespace # for billing and identification purposes

    # Optional
    environment-name       = var.environment-name
    infrastructure-support = var.infrastructure-support
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_id" "id" {
  byte_length = 8
}

# resource "random_id" "auth_token" {
#   byte_length = 32
#   keepers     = local.auth_token_rotation_seed
# }

locals {
  auth_token_rotation_seed = var.auth_token_rotated_date == "" ? {} : { "auth-token-rotated-date" = var.auth_token_rotated_date }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    SubnetType = "Private"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

resource "aws_security_group" "ec" {
  name        = "cp-${random_id.id.hex}"
  description = "Allow inbound traffic from kubernetes private subnets"
  vpc_id      = data.aws_vpc.selected.id

  # We cannot use `${aws_db_instance.rds.port}` here because it creates a
  # cyclic dependency. Rather than resorting to `aws_security_group_rule` which
  # is not ideal for managing rules, we will simply allow traffic to all ports.
  # This does not compromise security as the instance only listens on one port.
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

  tags = local.default_tags
}

// User and group for Redis Auth
resource "aws_elasticache_user" "ec_user" {
  user_id       = var.team_name + "-" + var.environment + "-ID"
  user_name     = var.team_name + "-" + var.environment
  access_string = "off ~keys* -@all +get"
  engine        = "REDIS"

  authentication_mode {
    type = "no-password-required"
  }
}

resource "aws_elasticache_user_group" "ec_group" {
  engine        = "REDIS"
  user_group_id = var.team_name + "-" + var.environment + "-ID"
  user_ids      = [aws_elasticache_user.default.user_id]

  lifecycle {
    ignore_changes = [user_ids]
  }
}

resource "aws_elasticache_user_group_association" "ec_group_association" {
  user_group_id = aws_elasticache_user_group.ec_group.user_group_id
  user_id       = aws_elasticache_user.ec_user.user_id
}

resource "aws_elasticache_replication_group" "ec_redis" {
  automatic_failover_enabled = true
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    var.number_cache_clusters,
  )
  replication_group_id       = "cp-${random_id.id.hex}"
  description                = "team=${var.team_name} / app=${var.application} / env=${var.environment-name}"
  engine                     = "redis"
  engine_version             = var.engine_version
  node_type                  = var.node_type
  num_cache_clusters         = var.number_cache_clusters
  parameter_group_name       = var.parameter_group_name
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.ec_subnet.name
  security_group_ids         = [aws_security_group.ec.id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = aws_elasticache_user.ec_user.auth_token
  user_group_ids             = aws_elasticache_user_group.ec_group.user_group_id
  apply_immediately          = true
  snapshot_window            = var.snapshot_window
  maintenance_window         = var.maintenance_window

  tags = local.default_tags
}

resource "aws_elasticache_subnet_group" "ec_subnet" {
  name       = "ec-sg-${random_id.id.hex}"
  subnet_ids = data.aws_subnets.private.ids

  tags = local.default_tags
}

resource "aws_iam_user" "user" {
  name = "cp-elasticache-${random_id.id.hex}"
  path = "/system/elasticache-user/"

  tags = local.default_tags
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "userpol" {
  name   = aws_iam_user.user.name
  policy = data.aws_iam_policy_document.policy.json
  user   = aws_iam_user.user.name
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "elasticache:ModifyReplicationGroup",
      "elasticache:DescribeReplicationGroups",
      "elasticache:DescribeCacheClusters",

    ]

    resources = [
      aws_elasticache_replication_group.ec_redis.arn,
      "arn:aws:elasticache:eu-west-2:754256621582:cluster:${aws_elasticache_replication_group.ec_redis.id}-*",
    ]
  }
}

