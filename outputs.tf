output "cache_nodes" {
    description = "List of node objects including id, address, port and availability_zone."
    value       = "${aws_elasticache_cluster.ec_cluster.cache_nodes.0.address}"
}
output "subnet_group_name" {
    description = "Name for the cache subnet group."
    value       = "${aws_elasticache_subnet_group.ec_subnet.name}"
}
output "subnet_group_ids" {
    description = "List of VPC Subnet IDs for the cache subnet group"
    value       = "${aws_elasticache_subnet_group.ec_subnet.subnet_ids}"
}