output "cache_nodes" {
  description = "List of node objects including id, address, port and availability_zone."
  value       = "${module.example_team_ec_cluster.cache_nodes}"
}

output "endpoint" {
  value = "${module.example_team_ec_cluster.endpoint}"
}
