
## DATA Object
## ----------------------------------------------------------------------------
## Data for Project ID and number
data "google_project" "project" {
  project_id = var.gcp_project_id
}

## IAM SERVICE ACCOUNT 
## ----------------------------------------------------------------------------
data "google_compute_default_service_account" "default" {
}

