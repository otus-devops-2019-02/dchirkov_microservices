terraform {
  required_version = ">=0.11,<0.12"
}

provider "google" {
  version = "2.3.0"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "gitlab_runners" {
  count = "${var.count}"
  name = "gitlab-runners${count.index}"
  machine_type = "${var.machine_type}"
  zone = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {
//      nat_ip = "${google_compute_address.gitlab_runners_ip.address}"
    }
  }
}

//resource "google_compute_address" "gitlab_runners_ip" {
//  name = "gitlab-runners-ip"
//}
