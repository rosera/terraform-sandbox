locals {
  service_account = "serviceAccount:${module.la_sa.iam_service_account}@${var.gcp_project_id}.iam.gserviceaccount.com"
}

# Basics: IAM Service Account Role
module "la_sa_role" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.service_account
  iam_sa_roles = ["roles/editor"]
}
