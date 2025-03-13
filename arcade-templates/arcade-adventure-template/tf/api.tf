# Module: Enable Google APIs
module "la_api_batch" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/api_service/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # API Delay hook - use this to perform a wait.
  api_create_duration = "120s"

  # Customise the services
  api_services = ["cloudfunctions.googleapis.com", "run.googleapis.com", "artifactregistry.googleapis.com", "cloudbuild.googleapis.com"]
}
