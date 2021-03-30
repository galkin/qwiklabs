resource "google_compute_instance" "bastion" {
  name         = "bastion"
  machine_type = "e2-micro"

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = google_compute_network.dev.id
    subnetwork = google_compute_subnetwork.dev-mgmt.id
  }
  network_interface {
    network    = google_compute_network.prod.id
    subnetwork = google_compute_subnetwork.prod-mgmt.id
  }
}

resource "google_compute_firewall" "dev" {
  name    = "bastion-dev"
  network = google_compute_network.dev.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["192.168.32.0/20"]
  source_tags   = ["bastion"]
}

resource "google_compute_firewall" "prod" {
  name    = "bastion-prod"
  network = google_compute_network.prod.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["192.168.32.0/20"]
  source_tags   = ["bastion"]
}
