#-----------------------------------------------------------------------------
# Build Frontend Application 

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project
#

#-----------------------------------------------------------------------------
# Module: Cloud Run 
module "la_cloud_run" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_run/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gcrService = "arcade-adventure"
  # TODO: Deploy local container image
  gcrImage   = "gcr.io/qwiklabs-resources/${var.container_image}"
  # gcrImage   = "gcr.io/${var.gcp_project_id}/arcade/${var.container_image}"
  # gcrRegion  = var.gcp_region 
  ## gcrEnvs    = [
  ##   { gcr_env_name = "STORAGE_URI", gcr_env_value = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net" },
  ##   { gcr_env_name = "STORAGE_ENDPOINT", gcr_env_value = "/arcade-1" }
  ## ]
}
