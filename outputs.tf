output "primary_endpoint_address" {
  description = "The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
  value       = aws_elasticache_replication_group.ec_redis.primary_endpoint_address
}

output "member_clusters" {
  description = "The identifiers of all the nodes that are part of this replication group."
  value       = aws_elasticache_replication_group.ec_redis.member_clusters
}

output "auth_token" {
  description = "The password used to access the Redis protected server."
  value       = aws_elasticache_replication_group.ec_redis.auth_token
}

output "replication_group_id" {
  value       = aws_elasticache_replication_group.ec_redis.replication_group_id
  description = "Redis cluster ID"
}

output "irsa_policy_arn" {
  description = "IAM policy ARN for access to rotate the Redis AUTH token"
  value       = aws_iam_policy.irsa.arn
}
