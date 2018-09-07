output "cache_nodes" {
  description = "List of node objects including id, address, port and availability_zone."
  value       = "${aws_elasticache_cluster.ec_cluster.cache_nodes}"
}

output "endpoint" {
  value = "${join(":", list(aws_elasticache_cluster.ec_cluster.0.address, aws_elasticache_cluster.ec_cluster.0.port))}"
}
