output "cache_nodes" {
  description = "List of node objects including id, address, port and availability_zone."
  value       = "${aws_elasticache_cluster.ec_cluster.cache_nodes}"
}

output "endpoint" {
  value = "${join(":", list(module.example_team_ec_cluster.0.address, module.example_team_ec_cluster.0.port))}"
}
