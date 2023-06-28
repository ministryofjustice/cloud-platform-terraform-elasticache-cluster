/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */
module "example_team_ec_cluster" {
  # always check the latest release in Github and set below
  source = "../"
  # source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=5.5"

  # VPC configuration
  vpc_name = var.vpc_name

  # Redis configuration
  engine_version       = "7.0"
  parameter_group_name = "default.redis7"
  node_type            = "cache.t4g.micro"

  # Tags
  team_name              = var.team_name
  namespace              = var.namespace
  business-unit          = var.business-unit
  application            = var.application
  is-production          = var.is-production
  environment-name       = var.environment-name
  infrastructure-support = var.infrastructure-support
}

resource "kubernetes_secret" "example_team_ec_cluster" {
  metadata {
    name      = "example-team-ec-cluster-output"
    namespace = "example-namespace"
  }

  data = {
    primary_endpoint_address = module.example_team_ec_cluster.primary_endpoint_address
    member_clusters          = jsonencode(module.example_team_ec_cluster.member_clusters)
    auth_token               = module.example_team_ec_cluster.auth_token
    access_key_id            = module.example_team_ec_cluster.access_key_id
    secret_access_key        = module.example_team_ec_cluster.secret_access_key
    replication_group_id     = module.example_team_ec_cluster.replication_group_id
  }
}
