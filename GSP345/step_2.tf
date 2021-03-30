provider "google" {
  project = var.project_id
  zone    = var.zone
  region  = var.region
}

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "project_id" {
}

resource "google_compute_instance" "first" {
  name         = "tf-instance-1"
  machine_type = "n1-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
  }
  allow_stopping_for_update = true
}

resource "google_compute_instance" "second" {
  name         = "tf-instance-2"
  machine_type = "n1-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
  }
  allow_stopping_for_update = true
}

resource "google_compute_instance" "three" {
  name         = "tf-instance-3"
  machine_type = "n1-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
  }
  allow_stopping_for_update = true
}

resource "google_storage_bucket" "backend" {
  name = var.project_id
}

resource "google_storage_bucket_object" "picture" {
  name    = "terraform/state/default.tfstate"
  content = "tfstate"
  bucket  = google_storage_bucket.backend.name
}
