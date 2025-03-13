## data "google_storage_project_service_account" "gcs_account" {
##   project = var.gcp_project_id
## }
## 
## module "la_sa_gcs_role" {
##   ## REMOTE: GitHub (Public) access - working 
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"
## 
##   ## Exchange values between Qwiklabs and Module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region 
##   gcp_zone       = var.gcp_zone 
## 
##   ## Custom Properties
##   # Pass the service account as principle member - non authorative binding
##   iam_sa_name  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
##   iam_sa_roles = [ "roles/pubsub.publisher" ]
## }

module "la_sa_cf" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_service_account/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass reference to the student username
  iam_sa_name        = var.gcp_cf_name 
  iam_sa_display     = "Cloud Function demo account" 
  iam_sa_description = "Cloud Function demo" 
}


# Basics: IAM Service Account Role 
# Local:  basics/iam_sa_role/dev
# Remote: github//basics/iam_sa_role/stable

## https://www.terraform.io/language/values/locals#using-local-values
## EXPECTS: 
## Output Variable from Module: la_service_account `module.la_sa.iam_service_account`
## Reference: https://cloud.google.com/billing/docs/reference/rest/v1/Policy#Binding
## TODO: Create/Set Service Account value
locals {
  cf_service_account = "serviceAccount:${module.la_sa_cf.iam_service_account}@${var.gcp_project_id}.iam.gserviceaccount.com"
}

# Cloud Function: Service Account
module "la_sa_cf_role" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.cf_service_account
  # iam_sa_roles = [ "roles/run.admin", "roles/run.invoker", "roles/cloudfunctions.admin", "roles/storage.admin", "roles/eventarc.admin", "roles/pubsub.admin", "roles/iam.serviceAccountUser", "roles/eventarc.serviceAgent" ] 
  iam_sa_roles = [ "roles/storage.objectCreator", "roles/cloudfunctions.serviceAgent", "roles/eventarc.eventReceiver", "roles/iam.serviceAccountUser" ] 
}
