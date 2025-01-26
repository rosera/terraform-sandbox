# Module: Google Compute Engine
module "la_gce_internal" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gce_instance/stable/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name            = var.gce_one_name
  gce_metadata        = var.gce_one_metadata
  gce_startup_script  = var.gce_one_startup_script # null || "${file("./scripts/lab-init.sh")}"
  gce_machine_type    = var.gce_one_machine_type
  gce_tags            = var.gce_one_tags
  gce_machine_image   = var.gce_one_machine_image
  gce_machine_network = module.la_vpc_internal.vpc_subnetwork_name # "default" || google_compute_subnetwork.dev_subnet.name
  gce_scopes          = var.gce_one_scopes
  gce_service_account = var.gce_one_service_account
}
