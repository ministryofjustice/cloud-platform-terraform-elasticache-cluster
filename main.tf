data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_elasticache_cluster" "ec_cluster" {
  cluster_id           = "${var.cluster_id}"
  engine               = "${var.ec_engine}"
  engine_version       = "${var.engine_version}"
  node_type            = "${var.node_type}"
  num_cache_nodes      = "${var.number_of_nodes}"
  parameter_group_name = "${var.parameter_group_name}"
  port                 = "${var.port}"

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
  name       = "${var.application}-${var.environment-name}-ec-subnet-group"
  subnet_ids = "${var.ec_subnet_groups}"

  tags {
        business-unit           = "${var.business-unit}"
        application             = "${var.application}"
        is-production           = "${var.is-production}"
        environment-name        = "${var.environment-name}"
        owner                   = "${var.team_name}"
        infrastructure-support  = "${var.infrastructure-support}"
    }
}

resource "aws_elasticache_security_group" "ec_sg" {
  name                 = "elasticache-security-group"
  security_group_names = ["${var.ec_vpc_security_group_ids}"]

  tags {
        business-unit           = "${var.business-unit}"
        application             = "${var.application}"
        is-production           = "${var.is-production}"
        environment-name        = "${var.environment-name}"
        owner                   = "${var.team_name}"
        infrastructure-support  = "${var.infrastructure-support}"
    }
}