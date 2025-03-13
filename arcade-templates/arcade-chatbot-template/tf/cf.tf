#-----------------------------------------------------------------------------
# Module: Cloud Functions
module "la_gcf" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/stable"
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function_g2/dev"

  # Pass values to the module
  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  gcp_zone             = var.gcp_zone

  # Customise the Cloud Storage
  gcs_bucket_extension = "arcade"

  # Customise the Cloud Function
  gcf_name             = "arcade-1"
  gcf_description      = "Arcade Game Endpoint"
  gcf_runtime          = "nodejs20"
  gcf_target_bucket    = "mybucket"
  gcf_archive_source   = "./cf/function.zip"
  gcf_entry_point      = "createStorageFile"
  gcf_environment_variables = {
    PROJECT_ID = var.gcp_project_id
    BUCKETNAME = "${var.gcp_project_id}-bucket" 
    FILENAME   = "arcade.txt"
    CONTENT    = "arcade"
  }
}


