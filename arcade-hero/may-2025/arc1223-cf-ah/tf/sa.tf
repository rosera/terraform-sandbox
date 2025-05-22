# Data: google_project 
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project

data "google_project" "project" {
  project_id = var.gcp_project_id
}


# Module: Bind Service Account to Role 
#-----------------------------------------------------------------------------
locals {
  #  PROJECT_NUMBER@cloudbuild.gserviceaccount.com
  # service-764015725287@gs-project-accounts.iam.gserviceaccount.com
  service_agent_sa = "serviceAccount:service-${data.google_project.project.number}@gs-project-accounts.iam.gserviceaccount.com"
  compute_dev_sa  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Module: Bind Service Account to Role 
#-----------------------------------------------------------------------------
module "la_sa_role" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.service_account
  iam_sa_roles = ["roles/storage.admin"]
}

## https://www.terraform.io/language/values/locals#using-local-values
## EXPECTS: 
## Output Variable from Module: la_service_account `module.la_sa.iam_service_account`
## Reference: https://cloud.google.com/billing/docs/reference/rest/v1/Policy#Binding
## TODO: Create/Set Service Account value
locals {
  arcade_hero_sa = "serviceAccount:${module.la_arcade_sa.iam_service_account}@${var.gcp_project_id}.iam.gserviceaccount.com"
}

module "la_arcade_sa" {
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

module "la_arcade_sa_role" {
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.arcade_hero_sa
  iam_sa_roles = [ "roles/storage.admin", "roles/pubsub.admin", "roles/eventarc.eventReceiver" ] 
}

module "la_developer_sa_role" {
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.compute_dev_sa
  iam_sa_roles = [ "roles/storage.admin", "roles/pubsub.admin", "roles/eventarc.eventReceiver" ] 
}

module "la_project_sa_role" {
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.compute_dev_sa
  iam_sa_roles = [ "roles/pubsub.publisher" ] 
}
