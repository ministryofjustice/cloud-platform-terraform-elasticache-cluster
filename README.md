# cloud-platform-terraform-elasticache-cluster
This Terraform module will create an ElastiCache Redis Cluster Replication Group in AWS. The module is built for the Redis engine. This module **does not** support Memcached.

## Usage

```hcl
module "example_team_ec_cluster" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster"

  // The first two inputs are provided by the pipeline for cloud-platform. See the example for more detail.

  cluster_name                  = "cloud-platform-live-0"
  cluster_state_bucket          = "live-0-state-bucket"
  team_name                     = "example-repo"
  engine_version                = "4.0.10"
  parameter_group_name          = "default.redis4.0"
  node_type                     = "cache.m3.medium"
  number_cache_clusters         = "3"
  replication_group_description = "example description"
  business-unit                 = "example-bu"
  application                   = "exampleapp"
  is-production                 = "false"
  environment-name              = "development"
  infrastructure-support        = "example-team@digtal.justice.gov.uk"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| engine_version | Redis ElastiCache engine version | string | `4.0.10` | no |
| parameter_group_name | ElastiCache engine parameter group name| string | `default.redis4.0` | no |
| node_type | The instance type of the EC cluster | string | `cache.m3.medium` | no |
| cluster_name | The name of the cluster (eg.: cloud-platform-live-0) | string | - | yes |
| cluster_state_bucket | The name of the S3 bucket holding the terraform state for the cluster | string | - | yes |


### Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidence](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

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
| primary_endpoint_address | The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled. |
| member_clusters | The identifiers of all the nodes that are part of this replication group. |
| auth_token | The password used to access the Redis protected server. |

## Access outside the cluster

Your redis instance is reachable only from the cluster pods; for tasks like inspecting your cache, import `kubectl forward` can create an authenticated tunnel, with a 2-step process:

1. Create a forwarding pod, any small image that does TCP will do:
```
kubectl --context live-0 -n NAMESPACE run port-forward --generator=run-pod/v1 --image=djfaze/port-forward --port=6379 --env="REMOTE_HOST=REDIS_HOST" --env="REMOTE_PORT=6379"
```
2. Forward the DB port
```
kubectl --context live-0 -n NAMESPACE port-forward port-forward 6379:80
```

3. Install [stunnel](https://www.stunnel.org/) via your package manager

4. Create a stunnel config (redis-ssl.conf) that looks like
```
fips = no
foreground = yes
pid = stunnel.pid
debug = 7
delay = yes
options = NO_SSLv2
options = NO_SSLv3
[redis-cli]
   client = yes
   accept = 127.0.0.1:6380
   connect = 127.0.0.1:6379
```

5. Create your secure tunnel
```
sudo stunnel redis-ssl.conf
```

With this, client tools can access Redis via 127.0.0.1 on port 6380. Note, you need to provide your password

```
redis-cli -u redis://:PASSWORD@127.0.0.1:6380
```


## Reading Material

- https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html
