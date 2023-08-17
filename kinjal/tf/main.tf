# Output: module.la_sa.iam_service_account
# Output: iam_service_account

module "la_sa" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_service_account/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass reference to the student username
  iam_sa_name = "lab-developer" 
  iam_sa_display = "BQ Cloud Function service account" 
  iam_sa_description = "Lab developer service account" 
}


## https://www.terraform.io/language/values/locals#using-local-values
locals {
  # service_account = "serviceAccount:${google_service_account.service_account.account_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
  service_account = "serviceAccount:${module.la_sa.iam_service_account}@${var.gcp_project_id}.iam.gserviceaccount.com"
}

module "la_sa_role" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Ensure member is formatted as per:  https://cloud.google.com/billing/docs/reference/rest/v1/Policy#Binding
  iam_sa_name  = local.service_account 
  iam_sa_roles = [ "roles/cloudbuild.integrations.editor", "roles/cloudbuild.builds.editor", "roles/artifactregistry.serviceAgent", "roles/run.developer", "roles/run.invoker", "roles/run.serviceAgent", "roles/compute.instanceAdmin.v1", "roles/cloudfunctions.developer", "roles/cloudfunctions.serviceAgent", "roles/cloudfunctions.invoker", "roles/bigquery.jobUser", "roles/bigquery.metadataViewer", "roles/bigquery.user"  ] 
}

# API Service:   Enable GoogleAPIs 
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Google Compute Engine
module "la_api_run" {
  ## TODO: Change from the DEV channel
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "run.googleapis.com", "bigqueryconnection.googleapis.com", "cloudfunctions.googleapis.com", "cloudbuild.googleapis.com", "artifactregistry.googleapis.com" ] 
}


## # API Service:   Enable GoogleAPIs 
## 
## # Module: API Service 
## module "la_api_run" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   api_service_name = "run.googleapis.com"  
## }
## 
## module "la_api_bqconnection" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   api_service_name = "bigqueryconnection.googleapis.com"  
## }
## 
## module "la_api_cf" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   api_service_name = "cloudfunctions.googleapis.com"  
## }
## 
## module "la_api_cloudbuild" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   api_service_name = "cloudbuild.googleapis.com"  
## }
## 
## module "la_api_artifactregistry" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   api_service_name = "artifactregistry.googleapis.com"  
## }
