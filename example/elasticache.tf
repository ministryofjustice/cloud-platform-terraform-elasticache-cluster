/*
 * When using this module through the cloud-platform-environments, the following
 * two variables are automatically supplied by the pipeline.
 *
 */

variable "cluster_name" {
}

/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */
module "example_team_ec_cluster" {
  # always check the latest release in Github and set below
  source                 = "../"
  # source                 = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=5.2"
  cluster_name           = var.cluster_name
  team_name              = "example-repo"
  namespace              = "example-namespace"
  business-unit          = "example-bu"
  application            = "exampleapp"
  is-production          = "false"
  environment-name       = "development"
  infrastructure-support = "example-team@digtal.justice.gov.uk"

  providers = {
    aws = aws.london
  }
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
  }
}

