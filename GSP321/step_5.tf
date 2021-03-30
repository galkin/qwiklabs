resource "google_container_cluster" "primary" {
  name                     = "griffin-dev"
  location                 = "us-east1-b"
  network                  = google_compute_network.dev.id
  subnetwork               = google_compute_subnetwork.dev-wp.id
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "nodes" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.primary.name
  node_count = 2
  node_config {
    machine_type = "n1-standard-4"
  }
}
