terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-1"
}

/*
 * When using this module through the cloud-platform-environments, the following
 * two variables are automatically supplied by the pipeline.
 *
 */

variable "cluster_name" {}

variable "cluster_state_bucket" {}

/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */
module "example_team_ec_cluster" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=2.0"

  cluster_name           = "${var.cluster_name}"
  cluster_state_bucket   = "${var.cluster_state_bucket}"
  team_name              = "example-repo"
  business-unit          = "example-bu"
  application            = "exampleapp"
  is-production          = "false"
  environment-name       = "development"
  infrastructure-support = "example-team@digtal.justice.gov.uk"
}

resource "kubernetes_secret" "example_team_ec_cluster" {
  metadata {
    name      = "example-team-ec-cluster-output"
    namespace = "my-namespace"
  }

  data {
    primary_endpoint_address = "${module.example_team_ec_cluster.primary_endpoint_address}"
    member_clusters          = "${module.example_team_ec_cluster.member_clusters}"
    auth_token               = "${module.example_team_ec_cluster.auth_token}"
  }
}
