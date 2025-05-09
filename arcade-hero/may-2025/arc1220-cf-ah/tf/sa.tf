## https://www.terraform.io/language/values/locals#using-local-values
## EXPECTS: 
## Output Variable from Module: la_service_account `module.la_sa.iam_service_account`
## Reference: https://cloud.google.com/billing/docs/reference/rest/v1/Policy#Binding
## TODO: Create/Set Service Account value
locals {
  service_account = "serviceAccount:${module.la_sa.iam_service_account}@${var.gcp_project_id}.iam.gserviceaccount.com"
}

module "la_sa" {
  ## NOTE: When changing the `source` parameter
  ## `terraform init` is required

  ## https://www.terraform.io/language/modules/sources#selecting-a-revision
  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  ## source = "./basics/iam_service_account/stable"

  ## REMOTE: GitHub (Public) access - working 
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_service_account/dev?ref=tlf_iam"

  ## REMOTE: GitHub (Public) access - working 
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_service_account/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_service_account/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass reference to the student username
  iam_sa_name = "hero-sa" 
  iam_sa_display = "Arcade Hero SA" 
  iam_sa_description = "Arcade Hero service account" 
}

# Basics: IAM Service Account Role 
# Local:  basics/iam_sa_role/dev
# Remote: github//basics/iam_sa_role/stable

module "la_sa_role" {
  ## NOTE: When changing the `source` parameter
  ## `terraform init` is required

  ## https://www.terraform.io/language/modules/sources#selecting-a-revision
  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  ## source = "./basics/iam_sa_role/stable"

  ## REMOTE: GitHub (Public) access - working 
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/dev?ref=tlf_iam"

  ## REMOTE: GitHub (Public) access - working 
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.service_account
  iam_sa_roles = [ "roles/storage.admin", "roles/pubsub.admin", "roles/eventarc.eventReceiver" ] 
}
