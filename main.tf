data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  engine_version       = ""
  node_type            = "cache.m3.medium"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  port                 = 6379
}