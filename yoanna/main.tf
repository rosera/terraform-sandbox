# API + Services: Enable Googleapis   
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]


# Module: Virtual Private Cloud 
module "la_pubsub" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  api_service_name = "pubsub.googleapis.com"
}

module "la_dataflow" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  api_service_name = "dataflow.googleapis.com"
}
