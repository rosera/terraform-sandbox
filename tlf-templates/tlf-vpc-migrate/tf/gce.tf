module "la_gce" {
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name              = "demo-vm"
  # gce_machine_network = "default"
  gce_machine_network   = module.la_vpc.vpc_subnet_self_link
  gce_metadata          = null
  # gce_startup_script   = null
  # gce_startup_script   = "${file("./scripts/lab-init.sh")}"

  ## Overrides
  gce_machine_type    = "e2-micro"
  gce_tags            = ["lab-vm"]
  gce_scopes          = ["cloud-platform"]
}
