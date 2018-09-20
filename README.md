# cloud-platform-terraform-elasticache-cluster
This Terraform module will create an ElastiCache Redis Cluster Replication Group in AWS. The module is built with the Redis engine. This module **does not** supports Memcached. The Terraform module will also create an ElastiCache subnet group.

The ElastiCache Cluster that's created will have a partly randomly generated name and as the user, you will have no control over it's name. This is to ensure the name complies with the strict validation checks. The name will take the form of `cp-${random_id.id.hex}` with a hex string length of 8 alphanumeric characters.

The ElastiCache Cluster will be deployed into the `live-0` VPC. This is done through the `aws_elasticache_subnet_group` resource which makes reference to the subnet group list for `live-0` which is the set default in the `variables.tf` file.

## Usage

```hcl
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
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| replication_group_description | A short description of the Redis replication group. | string | - | yes |
| engine_version | Redis ElastiCache engine version | string | `4.0.10` | no |
| parameter_group_name | ElastiCache engine parameter group name| string | `default.redis4.0` | no |
| node_type | The instance type of the EC cluster | string | `cache.m3.medium` | no |
| number_cache_clusters | The number of cache clusters (primary and replicas) this replication group will have. | string | 3 | no
| cluster_name | The name of the cluster (eg.: cloud-platform-live-0) | string | - | yes |
| cluster_state_bucket | The name of the S3 bucket holding the terraform state for the cluster | string | - | yes |


### Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to MOJ techincal guidence. The tags are stored as variables that you will need to fill out as part of your module.

https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| ID | The ID of the ElastiCache Replication Group. |
| primary_endpoint_address | The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled. |
| member_clusters | The identifiers of all the nodes that are part of this replication group. |
| auth_token | The password used to access the Redis protected server. |

## Reading Material

- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html
