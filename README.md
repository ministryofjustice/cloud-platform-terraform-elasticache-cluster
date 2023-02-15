# cloud-platform-terraform-elasticache-cluster

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-elasticache-cluster/all.svg" alt="Releases" />
</a>

This Terraform module will create an ElastiCache Redis Cluster Replication Group in AWS. The module is built for the Redis engine. This module **does not** support Memcached.

## Usage

```hcl
module "example_team_ec_cluster" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=version"

  # The first two inputs are provided by the pipeline for cloud-platform. See the example for more detail.
  vpc_name               = var.vpc_name
  team_name              = "example-repo"
  business-unit          = "example-bu"
  application            = "exampleapp"
  is-production          = "false"
  environment-name       = "development"
  infrastructure-support = "example-team@digtal.justice.gov.uk"
  providers = {
    aws = aws.london
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.27.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.27.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_replication_group.ec_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.ec_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_access_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.userpol](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_security_group.ec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_id.auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of your application | `string` | n/a | yes |
| <a name="input_auth_token_rotated_date"></a> [auth\_token\_rotated\_date](#input\_auth\_token\_rotated\_date) | Process to spin new auth token. Pass date to regenerate new token | `string` | `""` | no |
| <a name="input_business-unit"></a> [business-unit](#input\_business-unit) | Area of the MOJ responsible for the service | `string` | `"mojdigital"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The engine version that your ElastiCache Cluster will use. This will differ between the use of 'redis' or 'memcached'. The default is '5.0.6' with redis being the assumed engine. | `string` | `"5.0.6"` | no |
| <a name="input_environment-name"></a> [environment-name](#input\_environment-name) | The name of your environment | `string` | n/a | yes |
| <a name="input_infrastructure-support"></a> [infrastructure-support](#input\_infrastructure-support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | n/a | yes |
| <a name="input_is-production"></a> [is-production](#input\_is-production) | Whether this is a production ElastiCache cluster | `string` | `"false"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: `sun:05:00-sun:09:00`. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The name of your namespace | `string` | n/a | yes |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The cache node type for your cluster. The next size up is cache.m4.large | `string` | `"cache.t2.medium"` | no |
| <a name="input_number_cache_clusters"></a> [number\_cache\_clusters](#input\_number\_cache\_clusters) | The number of cache clusters (primary and replicas) this replication group will have. Default is 2 | `string` | `"2"` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the parameter group to associate with this cache cluster. Again this will differ between the use of 'redis' or 'memcached' and your engine version. The default is 'default.redis5.0'. | `string` | `"default.redis5.0"` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00 | `string` | `""` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | The name of your development team | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the vpc (eg.: live-1) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | Access key id for elasticache |
| <a name="output_auth_token"></a> [auth\_token](#output\_auth\_token) | The password used to access the Redis protected server. |
| <a name="output_member_clusters"></a> [member\_clusters](#output\_member\_clusters) | The identifiers of all the nodes that are part of this replication group. |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled. |
| <a name="output_replication_group_id"></a> [replication\_group\_id](#output\_replication\_group\_id) | Redis cluster ID |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | Secret key for elasticache |
<!-- END_TF_DOCS -->

## Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidence](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |

## Access outside the cluster

Your redis instance is reachable only from inside the cluster VPC, but you can use the same technique to access it from your development environment as for [accessing an RDS instance](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/other-topics/rds-external-access.html#accessing-your-rds-database)

1. Run a port-forward pod

```
kubectl \
  -n [your namespace] \
  run port-forward-pod \
  --generator=run-pod/v1 \
  --image=ministryofjustice/port-forward \
  --port=6379 \
  --env="REMOTE_HOST=[your redis cluster hostname]" \
  --env="LOCAL_PORT=6379" \
  --env="REMOTE_PORT=6379"
```

2. Forward local traffic to the port-forward-pod

```
kubectl \
  -n [your namespace] \
  port-forward \
  port-forward-pod 6379:6379
```

You need to leave this running as long as you are accessing the redis cluster.

3. Use the ruby redis client to access redis

> At the time of writing, the `redis-cli` command-line tool cannot use encrypted redis connections (i.e. those with a URL starting `rediss://...` as opposed to `redis://...`). So, this section describes how to use the `redis` ruby gem to connect to your elasticache cluster.

```
export REDIS_URL=[modified URL from namespace secret]
```

The value here should be the redis URL from your namespace secret, but with the hostname replaced with `localhost`

For instance, if the redis URL in your namespace secret is this:

```
url: rediss://dummyuser:6a36be5513564382b436b36be55e15a5@master.cp-8f56be55d06be5548.iwfvzo.euw2.cache.amazonaws.com:6379
```

...then the value you need for `REDIS_URL` is:

```
rediss://dummyuser:6a36be5513564382b436b36be55e15a5@localhost:6379
```

Then you can use the ruby redis client like this:

```
ruby -r redis -e 'redis = Redis.new(uri: ENV.fetch("REDIS_URL")); redis.set("foo", 123); puts redis.get("foo")'
```
