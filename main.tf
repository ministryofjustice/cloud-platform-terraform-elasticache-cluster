locals {
  # Generic configuration
  auth_token_rotation_seed = var.auth_token_rotated_date == "" ? {} : { "auth-token-rotated-date" = var.auth_token_rotated_date }

  # Tags
  default_tags = {
    # Mandatory
    business-unit = var.business_unit
    application   = var.application
    is-production = var.is_production
    owner         = var.team_name
    namespace     = var.namespace # for billing and identification purposes

    # Optional
    environment-name       = var.environment_name
    infrastructure-support = var.infrastructure_support
  }
}

########################
# Generate identifiers #
########################
resource "random_id" "id" {
  byte_length = 8
}

resource "random_id" "auth_token" {
  byte_length = 32
  keepers     = local.auth_token_rotation_seed
}

#######################
# Get VPC information #
#######################
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

data "aws_availability_zones" "available" {
  state = "available"
}

##########################
# Create Security Groups #
##########################
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

##############################
# Create ElastiCache cluster #
##############################
resource "aws_elasticache_replication_group" "ec_redis" {
  automatic_failover_enabled = true
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    var.number_cache_clusters,
  )
  replication_group_id       = "cp-${random_id.id.hex}"
  description                = "team=${var.team_name} / app=${var.application} / env=${var.environment_name}"
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
  auth_token                 = random_id.auth_token.hex
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

#################################
# Legacy long-lived credentials #
#################################
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
      "arn:aws:elasticache:eu-west-2:${data.aws_region.current.name}:cluster:${aws_elasticache_replication_group.ec_redis.id}-*",
    ]
  }
}

##################################
# Short-lived (IRSA) credentials #
##################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "irsa" {
  version = "2012-10-17"
  statement {
    sid    = "AllowRotateRedisAUTHToken"
    effect = "Allow"
    actions = [
      "elasticache:ModifyReplicationGroup",
      "elasticache:DescribeReplicationGroups",
      "elasticache:DescribeCacheClusters",
    ]
    resources = [
      aws_elasticache_replication_group.ec_redis.arn,
      "arn:aws:elasticache:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster:${aws_elasticache_replication_group.ec_redis.id}-*",
    ]
  }
}

resource "aws_iam_policy" "irsa" {
  name   = "cloud-platform-elasticache-${random_id.id.hex}"
  path   = "/cloud-platform/elasticache/"
  policy = data.aws_iam_policy_document.irsa.json
  tags   = local.default_tags
}
