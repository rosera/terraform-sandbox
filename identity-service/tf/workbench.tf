


// Create a Vertex AI Workbench Instance
module "la_vai_workbench" {
  source                  = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vai_workbench/stable/v1"
  gcp_project_id          = var.gcp_project_id
  gcp_region              = var.gcp_region
  gcp_zone                = var.gcp_zone
  vai_workbench_name      = var.workbench_name
  vai_post_startup_script = "gs://${module.lab_config_bucket.gcs_bucket_name}/notebook_config.sh"

  ## Add a Custom Delay before creating a Workbench instance
  depends_on              = [ resource.time_sleep.wait_identity_delay ]
#  depends_on              = [module.la_api_batch, google_storage_bucket_object.notebook_config_script]
}
