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
    network    = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[0]
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
    network    = module.vpc.network_name
    subnetwork = module.vpc.subnets_names[1]
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

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.5.0"

  project_id   = var.project_id
  network_name = "terraform-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "us-central1"
    },
    {
      subnet_name           = "subnet-02"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    }
  ]
}

resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = module.vpc.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]
}
