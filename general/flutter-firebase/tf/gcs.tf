resource "google_storage_bucket" "default" {
    provider = google-beta
    project  = var.gcp_project_id 
    name     = "${var.gcp_project_id}-fb-webapp"
    location = "US"
}

