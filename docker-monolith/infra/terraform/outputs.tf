output "reddit_external_name" {
  value = "${google_compute_instance.docker-reddit.*.name}"
}

output "reddit_external_ip" {
  value = "${google_compute_instance.docker-reddit.*.network_interface.0.access_config.0.nat_ip}"
}
