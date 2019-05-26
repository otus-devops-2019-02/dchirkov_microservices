terraform {
  required_version = ">=0.11,<0.12"
}

provider "google" {
  version = "2.3.0"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "reddit" {
  name = "reddit"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "firewall_reddit" {
  name = "allow-reddit-app"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["reddit-app"]
}
