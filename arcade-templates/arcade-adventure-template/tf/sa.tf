# Basics: IAM Service Account 
module "la_sa" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_service_account/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_service_account/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## Custom Properties
  # Pass reference to the student username
  iam_sa_name        = "clslab-sa"
  iam_sa_display     = "Cloud Function service account"
  iam_sa_description = "Cloud Function lab service account"
}
