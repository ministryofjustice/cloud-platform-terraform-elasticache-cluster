# cloud-platform-terraform-elasticache-cluster

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-elasticache-cluster/all.svg" alt="Releases" />
</a>

This Terraform module will create an ElastiCache Redis Cluster Replication Group in AWS. The module is built for the Redis engine. This module **does not** support Memcached.

## Usage

```hcl
module "example_team_ec_cluster" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-elasticache-cluster?ref=version"

  // The first two inputs are provided by the pipeline for cloud-platform. See the example for more detail.
  cluster_name           = var.cluster_name
  cluster_state_bucket   = var.cluster_state_bucket
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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| engine_version | Redis ElastiCache engine version | string | `5.0.6` | no |
| parameter_group_name | ElastiCache engine parameter group name| string | `default.redis5.0` | no |
| node_type | The instance type of the EC cluster | string | `cache.m3.medium` | no |
| cluster_name | The name of the cluster (eg.: cloud-platform-live-0) | string | - | yes |
| cluster_state_bucket | The name of the S3 bucket holding the terraform state for the cluster | string | - | yes |
| providers |  providers to use (including region) | string | - | -



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
ruby -r redis -e 'redis = Redis.new(uri: ENV.fetch("REDIS_URL"); redis.set("foo", 123); puts redis.get("foo")'
```

