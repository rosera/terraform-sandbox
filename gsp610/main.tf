#-----------------------------------------------------------------------------
# Google Project: Project Data object
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project 
#-----------------------------------------------------------------------------
data "google_project" "project" {
     project_id = var.gcp_project_id
}

#-----------------------------------------------------------------------------
# locals: Local variable definition 
#-----------------------------------------------------------------------------
## Set the service 
locals {
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

#-----------------------------------------------------------------------------
# Module: IAM Service Account bind to a role
#-----------------------------------------------------------------------------
module "la_sa_role" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.service_account
  iam_sa_roles = ["roles/appengine.appAdmin"] 
}

#-----------------------------------------------------------------------------
# Module: Enable Cloud Firestore API 
#-----------------------------------------------------------------------------
# Module: Enable Google APIs
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "firestore.googleapis.com" ] 
}

#-----------------------------------------------------------------------------
# Module: Provision App Engine + Cloud Firestore
#-----------------------------------------------------------------------------
module "la_gae_database" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/app_engine/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GAE instance

  ## App Engine uses https://cloud.google.com/appengine/docs/standard/locations
  ## NOTE: This means locations are different for:
  ## US_CENTRAL1 is US_CENTRAL
  ## EUROPE_WEST1 is EUROPE_WEST

  gae_location    = var.gcp_region
  gae_hasDatabase = true 
  gae_db_type     = "CLOUD_FIRESTORE"
}

#-----------------------------------------------------------------------------
# CloudBuild: Perform Cloud Storage script 
# Reference:
# https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest
#-----------------------------------------------------------------------------
module "cloudbuild_script" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  # create_cmd_entrypoint = "gcloud"
  # create_cmd_body = "builds submit gs://spls/gsp610/cloudbuild.zip --project=${var.gcp_project_id}"
  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
  create_cmd_body = "${var.gcp_project_id}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file

  # Await App Engine deployment 
  module_depends_on = [
    module.la_gae_database
  ]
}
