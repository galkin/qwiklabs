provider "google" {}
provider "random" {}
data "google_project" "default" {}

resource "random_string" "bucket_name" {
  length  = 16
  number  = false
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "topic_name" {
  length  = 16
  number  = false
  special = false
  lower   = true
  upper   = false
}

module "event-function" {
  source  = "terraform-google-modules/event-function/google"
  version = "1.5.0"

  project_id = data.google_project.default.project_id
  region     = "us-central1"

  bucket_name   = random_string.bucket_name.result
  create_bucket = true

  name             = "thumbnail"
  description      = "n/a"
  entry_point      = "thumbnail"
  runtime          = "nodejs10"
  source_directory = "${abspath(path.module)}/src"

  event_trigger = {
    event_type = "google.storage.object.finalize"
    resource   = random_string.bucket_name.result
  }

  environment_variables = {
    TOPIC = random_string.topic_name.result
  }
}

resource "google_pubsub_topic" "this" {
  name = random_string.topic_name.result
}

resource "google_storage_bucket_object" "picture" {
  name   = "map.jpg"
  source = "${path.module}/static/map.jpg"
  bucket = random_string.bucket_name.result

  depends_on = [
    module.event-function
  ]
}
