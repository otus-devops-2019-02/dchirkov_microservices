terraform {
  required_version = ">=0.11,<0.12"
}

provider "google" {
  version = "2.3.0"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "gitlab_ci" {
  name = "gitlab-ci"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"
  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.gitlab_ci_ip.address}"
    }
  }
}

resource "google_compute_address" "gitlab_ci_ip" {
  name = "gitlab-ci-ip"
}
