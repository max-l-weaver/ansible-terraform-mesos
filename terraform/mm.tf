provider "google" {
  project = "${var.project_name}"
  region = "${var.region}"
  credentials = "${file("${var.credentials_file_path}")}"
}

resource "google_compute_http_health_check" "default" {
  name = "mm-ms-basic-health-check"
  request_path = "/"
  check_interval_sec = 1
  healthy_threshold = 1
  unhealthy_threshold = 10
  timeout_sec = 1
}

resource "google_compute_instance" "default" {
  count = 3

  name = "mm-test-${count.index + 1}"
  machine_type = "n1-standard-8"
  zone = "${var.zone}"

  tags = ["mesos-master", "mm"]

  disk {
    size = 50
    type = "pd-standard"
    image = "ubuntu-1604-xenial-v20161020"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
  ssh_keys = "${file("${var.public_key_path}")}"
  }

}

resource "google_compute_target_pool" "default" {
  name = "mesos-target-pool"
  instances = ["${google_compute_instance.default.*.self_link}", 
                  "${google_compute_instance.mesos-slave.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.default.name}"]
}

resource "google_compute_forwarding_rule" "default" {
  name = "mesos-forwarding-rule"
  target = "${google_compute_target_pool.default.self_link}"
  port_range = 80
}

resource "google_compute_firewall" "default" {
  name = "mesos-default-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

