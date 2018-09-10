output "cache_nodes" {
  description = "List of node objects including id, address, port and availability_zone."
  value       = "${module.example_team_ec_cluster.cache_nodes}"
}

output "endpoint" {
  value = "${lookup(module.example_team_ec_cluster.cache_nodes[0],"address")}:${lookup(module.example_team_ec_cluster.cache_nodes[0],"port")}"
}
