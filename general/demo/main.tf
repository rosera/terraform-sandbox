resource "google_storage_bucket" "bucket" {
  name          = var.gcp_project_id
  location      = var.gcp_region
  storage_class = "REGIONAL"
}
resource "random_string" "startup_labtitle" {
  length  = 5
  special = false
  upper   = false
}
