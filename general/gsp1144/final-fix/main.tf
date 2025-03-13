# Module: Enable Google APIs
# ----------------------------------------------------------------------------
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services   = [ "artifactregistry.googleapis.com" ] 
}

# Resource: Google PubSub Topic 
# ----------------------------------------------------------------------------
resource "google_pubsub_topic" "weather_sensor_trigger" {
  name    = "weather-sensor-trigger"
  project = var.gcp_project_id
}

# Locals: Variables 
# ----------------------------------------------------------------------------
locals {
  cloud_function_object = "function.zip"
  cloud_function_path   = "./cf/"
}

# Module: Cloud Functions
# ----------------------------------------------------------------------------
module "la_gcf" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/stable"
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/dev"

  # Pass values to the module
  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  gcp_zone             = var.gcp_zone

  # Customise the Cloud Storage
  gcs_bucket_extension = "bucket"

  # Customise the Cloud Function
  gcf_name                  = "sensor-data-generator"
  gcf_description           = "Defining a new function"
  gcf_runtime               = "python39"
  gcf_target_bucket         = "mybucket"
  gcf_archive_source        = "${local.cloud_function_path}${local.cloud_function_object}"
  gcf_archive_object        = "${local.cloud_function_object}"
  gcf_entry_point           = "hello_world"
  gcf_registry              = "CONTAINER_REGISTRY"
  gcf_available_mb          = 512
  gcf_timeout               = 540 
  gcf_trigger_security      = "SECURE_OPTIONAL"
  gcf_environment_variables = {
    PROJECT_ID = var.gcp_project_id
  }
}
