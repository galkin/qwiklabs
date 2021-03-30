resource "google_compute_network" "prod" {
  name                    = "griffin-prod-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "prod-wp" {
  name          = "griffin-prod-wp"
  ip_cidr_range = "192.168.48.0/20"
  network       = google_compute_network.prod.id
}

resource "google_compute_subnetwork" "prod-mgmt" {
  name          = "griffin-prod-mgmt"
  ip_cidr_range = "192.168.64.0/20"
  network       = google_compute_network.prod.id
}
