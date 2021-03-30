provider "kubectl" {
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)

  host             = google_container_cluster.primary.endpoint
  token            = data.google_client_config.current.access_token
  load_config_file = false
}
