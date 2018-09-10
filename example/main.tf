provider "aws" {
  region = "eu-west-1"
}

module "example_team_ec_cluster" {
  # source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=1.0"
  source = "../"

  team_name              = "example-repo"
  ec_engine              = "redis"
  engine_version         = "4.0.10"
  parameter_group_name   = "default.redis4.0"
  node_type              = "cache.m3.medium"
  number_of_nodes        = 1
  port                   = 6379
  business-unit          = "example-bu"
  application            = "exampleapp"
  is-production          = "false"
  environment-name       = "development"
  infrastructure-support = "example-team@digtal.justice.gov.uk"
}
