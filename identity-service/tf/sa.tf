data "google_project" "project" {
  project_id = var.gcp_project_id
}
 
locals {
  service_account = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
}

module "la_role_bind_aipfuser" {
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## TODO: 
  ## Replace with module.la_identity_service.service_account_member
  iam_sa_name  = local.service_account
  iam_sa_roles = ["roles/aiplatform.user", "roles/aiplatform.serviceAgent", "roles/storage.admin"]

  depends_on = [ resource.time_sleep.wait_identity_delay ]
  ## depends_on = [module.la_identity_service]
}
