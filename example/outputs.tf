output "id" {
  description = "The ID of the ElastiCache Replication Group."
  value       = "${module.example_team_ec_cluster.id}"
}

output "primary_endpoint_address" {
  description = "The address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
  value       = "${module.example_team_ec_cluster.primary_endpoint_address}"
}

output "member_clusters" {
  description = "The identifiers of all the nodes that are part of this replication group."
  value       = "${module.example_team_ec_cluster.member_clusters}"
}

output "auth_token" {
  description = "The password used to access the Redis protected server."
  value       = "${module.example_team_ec_cluster.auth_token}"
}