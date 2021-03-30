resource "google_compute_network" "dev" {
  name                    = "griffin-dev-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev-wp" {
  name          = "griffin-dev-wp"
  ip_cidr_range = "192.168.16.0/20"
  network       = google_compute_network.dev.id
}

resource "google_compute_subnetwork" "dev-mgmt" {
  name          = "griffin-dev-mgmt"
  ip_cidr_range = "192.168.32.0/20"
  network       = google_compute_network.dev.id
}
