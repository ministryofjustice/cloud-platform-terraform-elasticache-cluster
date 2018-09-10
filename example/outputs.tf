output "endpoint" {
  value = "${join(":", list(module.example_team_ec_cluster.0.address, module.example_team_ec_cluster.0.port))}"
}
