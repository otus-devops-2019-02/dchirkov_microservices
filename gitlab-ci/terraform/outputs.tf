output "reddit_external_name" {
  value = "${google_compute_instance.reddit.name}"
}

output "reddit_external_ip" {
  value = "${google_compute_instance.reddit.network_interface.0.access_config.0.nat_ip}"
}
