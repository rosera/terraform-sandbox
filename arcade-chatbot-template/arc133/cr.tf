#-----------------------------------------------------------------------------
# Module: Cloud Run 
module "la_cloud_run" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_run/stable"
  # source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/cloud_run/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gcrService = "genai-chatbot"
  # TODO: Deploy local container image
  # gcrImage   = "gcr.io/qwiklabs-resources/arcade/arcade-frontend-chat"
  # gcrImage   = "gcr.io/${var.gcp_project_id}/arcade/${var.container_image}"
  gcrImage = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${var.gcp_ar_name}/${var.container_image}"
  gcrRegion  = var.gcp_region 
  gcrEnvs    = [
    { gcr_env_name = "STORAGE_URI", gcr_env_value = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net" },
    { gcr_env_name = "STORAGE_ENDPOINT", gcr_env_value = "/arcade-1" }
  ]

  # WAIT before creating resource
  # depends_on = [  time_sleep.wait_api_delay ]
  depends_on = [  time_sleep.wait_build_delay ]
}
