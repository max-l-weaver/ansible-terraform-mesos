resource "google_compute_instance" "mesos-slave" {
  count = 3

  name = "ms-test-${count.index + 1}"
  machine_type = "n1-standard-8"
  zone = "${var.zone}"

  tags = ["mesos-slave", "ms"]

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
}