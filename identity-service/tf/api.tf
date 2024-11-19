// Enable the required Vertex AI services
module "la_api_batch" {
  source         = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/api_service/stable/v1"
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
  api_services = [
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "notebooks.googleapis.com",
    "aiplatform.googleapis.com",
    "datacatalog.googleapis.com",
    "visionai.googleapis.com"
  ]
}