# API Service:   Enable GoogleAPIs 
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Enable Google APIs
module "la_api_batch" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/api_service/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  # Ref: https://cloud.google.com/eventarc/standard/docs/run/create-trigger-storage-gcloud
  api_services = [ "run.googleapis.com", "eventarc.googleapis.com", "storage.googleapis.com", "pubsub.googleapis.com" ] 
}
