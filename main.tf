data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_id" "id" {
  byte_length = 8
}

resource "random_id" "auth_token" {
  byte_length = 32
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config {
    bucket = "${var.cluster_state_bucket}"
    region = "eu-west-1"
    key    = "env:/${var.cluster_name}/terraform.tfstate"
  }
}

resource "aws_security_group" "ec" {
  name        = "cp-${random_id.id.hex}"
  description = "Allow inbound traffic from kubernetes private subnets"
  vpc_id      = "${data.terraform_remote_state.cluster.vpc_id}"

  // We cannot use `${aws_db_instance.rds.port}` here because it creates a
  // cyclic dependency. Rather than resorting to `aws_security_group_rule` which
  // is not ideal for managing rules, we will simply allow traffic to all ports.
  // This does not compromise security as the instance only listens on one port.
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${data.terraform_remote_state.cluster.internal_subnets}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${data.terraform_remote_state.cluster.internal_subnets}"]
  }
}

resource "aws_elasticache_replication_group" "ec_redis" {
  automatic_failover_enabled    = true
  availability_zones            = ["${slice(data.terraform_remote_state.cluster.availability_zones,0,var.number_cache_clusters)}"]
  replication_group_id          = "cp-${random_id.id.hex}"
  replication_group_description = "team=${var.team_name} / app=${var.application} / env=${var.environment-name}"
  engine                        = "redis"
  engine_version                = "${var.engine_version}"
  node_type                     = "${var.node_type}"
  number_cache_clusters         = "${var.number_cache_clusters}"
  parameter_group_name          = "${var.parameter_group_name}"
  port                          = 6379
  subnet_group_name             = "${aws_elasticache_subnet_group.ec_subnet.name}"
  security_group_ids            = ["${aws_security_group.ec.id}"]
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  auth_token                    = "${random_id.auth_token.hex}"

  tags {
    business-unit          = "${var.business-unit}"
    application            = "${var.application}"
    is-production          = "${var.is-production}"
    environment-name       = "${var.environment-name}"
    owner                  = "${var.team_name}"
    infrastructure-support = "${var.infrastructure-support}"
  }
}

resource "aws_elasticache_subnet_group" "ec_subnet" {
  name       = "ec-sg-${random_id.id.hex}"
  subnet_ids = ["${data.terraform_remote_state.cluster.internal_subnets_ids}"]
}
