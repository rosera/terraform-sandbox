data "google_project" "project" {
    project_id = var.gcp_project_id
}

locals {
  ## service_account = "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

module "la_sa_role_cb" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.service_account
  iam_sa_roles = [ "roles/storage.admin", "roles/artifactregistry.admin" ] 
}

locals {
  ## service_account = "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
  ## service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  ar_service_account = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
}

module "la_sa_role_ar" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.ar_service_account
  iam_sa_roles = [ "roles/storage.objectViewer" ] 
}
