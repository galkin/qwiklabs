resource "google_sql_database_instance" "instance" {
  name             = "griffin-dev-db"
  region           = "us-east1"
  database_version = "MYSQL_5_6"
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = "true"
}

resource "google_sql_database" "database" {
  name     = "wordpress"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = "wp_user"
  instance = google_sql_database_instance.instance.name
  host     = "%"
  password = "stormwind_rules"
}
