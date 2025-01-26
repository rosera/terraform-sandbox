## Chatbot V3
#-----------------------------------------------------------------------------

# Module: Enable Google APIs
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "run.googleapis.com" ] 
}

#-----------------------------------------------------------------------------
# Build Frontend Application 

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project
#
data "google_project" "project" {
  project_id = var.gcp_project_id
}

#-----------------------------------------------------------------------------
# Module: Bind Service Account to Role 
locals {
  #  PROJECT_NUMBER@cloudbuild.gserviceaccount.com
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

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

## resource "time_sleep" "object_creation_delay" {
## 
##   create_duration = "300s"
##   depends_on = [ google_storage_bucket_object.persona_object, google_storage_bucket_object.task_object ]
## }

#-----------------------------------------------------------------------------
# Module: GCloud Task Runner
# Dependency: Google Cloud Storage Objects: persona.json + tasks.json
module "cloudbuild_script" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
  create_cmd_body = "${var.gcp_project_id} ${var.gcp_region} ${var.gcp_zone} ${var.container_image}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file

  # Wait for delay before proceeding 
  # depends_on = [ time_sleep.object_creation_delay ]
}

#-----------------------------------------------------------------------------
# Module: Cloud Run 
module "la_cloud_run" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_run/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gcrService = "genai-chatbot"
  # TODO: Deploy local container image
  # gcrImage   = "gcr.io/qwiklabs-resources/arcade/arcade-frontend-chat"
  gcrImage   = "gcr.io/${var.gcp_project_id}/arcade/${var.container_image}"
  gcrRegion  = var.gcp_region 
  gcrEnvs    = [
    { gcr_env_name = "STORAGE_URI", gcr_env_value = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net" },
    { gcr_env_name = "STORAGE_ENDPOINT", gcr_env_value = "/arcade-1" }
  ]
}
