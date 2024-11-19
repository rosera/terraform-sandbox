module "la_identity_service" {
  # source                   = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/identity_service/dev"
  # source                   = "github.com/CloudVLab/terraform-lab-foundation//basics/identity_service/dev?ref=tlf_si"
  source                   = "github.com/CloudVLab/terraform-lab-foundation//basics/identity_service/dev"
  gcp_project_id           = var.gcp_project_id
  gcp_region               = var.gcp_region
  gcp_zone                 = var.gcp_zone
  identity_create_duration = "60s"
  identity_services = [
    "aiplatform.googleapis.com"
  ]

  # depends_on = [module.la_api_batch]
}
 
# Introduce a JIT delay for API enablement
resource "time_sleep" "wait_identity_delay" {
  create_duration = "180s" 
  ## Add a Custom Delay after enabling identity service
  depends_on = [ module.la_identity_service.wait_identity_delay ]
}
