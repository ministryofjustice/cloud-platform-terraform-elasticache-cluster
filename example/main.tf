provider "aws" {
  region = "eu-west-1"
}

module "example_team_ec_cluster" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster"

  cluster_name           = "cloud-platform-live-0"
  cluster_state_bucket   = "moj-cp-k8s-investigation-platform-terraform"
  team_name              = "example-repo"
  engine_version         = "4.0.10"
  parameter_group_name   = "default.redis4.0"
  node_type              = "cache.m3.medium"
  number_cache_clusters  = "3"
  replication_group_description = "example description"
  business-unit          = "example-bu"
  application            = "exampleapp"
  is-production          = "false"
  environment-name       = "development"
  infrastructure-support = "example-team@digtal.justice.gov.uk"
}
