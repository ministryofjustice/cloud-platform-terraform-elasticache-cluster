provider "aws" {
  region = "eu-west-1"
}

module "example_team_ec_cluster" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=v1.0"

  team_name              = "example-repo"
  ec_engine              = "redis"
  engine_version         = "4.0.10"
  parameter_group_name   = "default.redis4.0"
  node_type              = "cache.m3.medium"
  number_of_nodes        = 1
  port                   = 6379
  ec_subnet_groups       = ["subnet-7293103a", "subnet-7bf10c21", "subnet-de00b3b8"]
  business-unit          = "example-bu"
  application            = "exampleapp"
  is-production          = "false"
  environment-name       = "development"
  infrastructure-support = "example-team@digtal.justice.gov.uk"
}
