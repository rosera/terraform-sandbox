## API ENABLE 
## ----------------------------------------------------------------------------
resource "google_project_service" "bq-connection-api" {
  project = var.gcp_project_id
  service = "servicenetworking.googleapis.com"
}

