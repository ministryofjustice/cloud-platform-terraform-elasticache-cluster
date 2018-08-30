module "example_team_ec_cluster" {
  source = "~/Users/ollieanwyll/Desktop/Repos/cloud-platform-terraform-elasticache-cluster/main.tf"

  team_name                 = "example-repo"
  ec_engine                 = "redis"
  engine_version            = "4.0.10"
  parameter_group_name      = "default.redis4.0"
  cluster_id                = "oa-example-123"
  node_type                 = "cache.m3.medium"
  number_of_nodes           = 2
  port                      = 6379
  ec_subnet_groups          = ["subnet-7293103a", "subnet-7bf10c21", "subnet-de00b3b8"]
  ec_vpc_security_group_ids = ["sg-7e8cf203", "sg-7e8cf203"]
  business-unit             = "example-bu"
  application               = "exampleapp"
  is-production             = "false"
  environment-name          = "development"
  infrastructure-support    = "example-team@digtal.justice.gov.uk"
}