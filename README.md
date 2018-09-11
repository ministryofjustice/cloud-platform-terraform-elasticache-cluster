# cloud-platform-terraform-elasticache-cluster
This Terraform module will create an ElastiCache Cluster in AWS. The module is built with the Redis engine assumed as the default, as it's used far more than Memcached. This module still supports Memcached. The Terraform module will also create an ElastiCache subnet group.

The ElastiCache Cluster that's created will have a partly randomly generated name and as the user, you will have no control over it's name. This is to ensure the name complies with the strict validation checks. The name will take the form of `cp-${random_id.id.hex}` with a hex string length of 8 alphanumeric characters.

The ElastiCache Cluster will be deployed into the `live-0` VPC. This is done through the `aws_elasticache_subnet_group` resource which makes reference to the subnet group list for `live-0` which is the set default in the `variables.tf` file.

## Usage

```hcl
module "example_team_ec_cluster" {
    source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster"

    team_name                 = "example-team"
    ec_engine                 = "redis"
    engine_version            = "4.0.10"
    parameter_group_name      = "default.redis4.0"
    node_type                 = "cache.m3.medium"
    number_of_nodes           = 1
    port                      = 6379
    business-unit             = "example-bu"
    application               = "exampleapp"
    is-production             = "false"
    environment-name          = "development"
    infrastructure-support    = "example-team@digtal.justice.gov.uk"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ec_engine | ElastiCache engine | string | `redis` | no |
| engine_version | ElastiCache engine version | string | `4.0.10` | no |
| parameter_group_name | ElastiCache engine parameter group name| string | `default.redis4.0` | no |
| node_type | The instance type of the EC cluster | string | `cache.m3.medium` | no |
| number_of_nodes | Number of nodes in the cluster | string | 1 | no
| port | Port number of the EC Cluster | string | `6379` | no |
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
| cache_nodes | List of node objects including id, address, port and availability_zone |


## Reading Material

- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html
