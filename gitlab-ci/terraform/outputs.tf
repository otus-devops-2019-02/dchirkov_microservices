output "gitlab_ci_external_ip" {
  value = "${google_compute_instance.gitlab_runner.network_interface.0.access_config.0.nat_ip}"
}
