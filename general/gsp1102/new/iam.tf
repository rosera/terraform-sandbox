## IAM ROLE
## ----------------------------------------------------------------------------
## Adding the IAM role to the lab created student account for token0s

resource "google_service_account" "service_account" {
  account_id   = "compute-startup"
  display_name = "SA for lab startup"
}

resource "google_service_account_iam_member" "owner_sa_role_bind" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/owner"
  member             = "serviceAccount:${google_service_account.service_account.email}"
}

## IAM ROLE MEMBER
## ----------------------------------------------------------------------------
resource "google_project_iam_member" "compute-owner-bind" {
  project = var.gcp_project_id
  role    = "roles/owner"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

// Adding the IAM role to the compute engine account for tokens
resource "google_project_iam_member" "compute-owner-bind1" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountOpenIdTokenCreator"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "compute-owner-bind2" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

## IAM ROLE BINDING
## ----------------------------------------------------------------------------
resource "google_project_iam_binding" "binding" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountOpenIdTokenCreator"
  members = ["user:${var.gcp_username}@qwiklabs.net"]
}

resource "google_project_iam_binding" "binding1" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["user:${var.gcp_username}@qwiklabs.net"]
}
