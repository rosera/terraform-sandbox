resource "google_artifact_registry_repository" "my-repo" {
  location = var.gcp_region
  project  = var.gcp_project_id
  repository_id = var.cb_ar_name
  description   = "Arcade Labs Repository"
  format        = "Docker"
}

