## API Service module
module "la_api_batch" {
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the Googleapis 
  api_services = [ "run.googleapis.com", "iam.googleapis.com", "compute.googleapis.com", "artifactregistry.googleapis.com", "containerregistry.googleapis.com", "aiplatform.googleapis.com", "cloudbuild.googleapis.com", "notebooks.googleapis.com" ]
}
