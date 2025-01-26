# EXTERNAL 

# Module: Virtual Private Cloud 
module "la_vpc_external" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_network/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vpc_network/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the VPC 
  vpc_network             = var.vpc_two_name
  vpc_network_description = var.vpc_two_name
  vpc_subnet              = "${var.vpc_two_name}-${var.gcp_region}"
  vpc_region              = var.gcp_region
  vpc_subnet_cidr         = var.vpc_two_cidr
}

# Module: Compute Firewall 
module "la_fw_external" {
  ## REMOTE: GitHub (Public) access - working 
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_firewall/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vpc_firewall/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
  fwr_network    = module.la_vpc_external.vpc_network_name

  # Firewall Policy - Repeatable list of objects
  fwr_rules = [
    {
      fwr_name                    = var.fwr_two_name
      fwr_description             = var.fwr_two_name
      fwr_source_ranges           = var.fwr_two_source_range
      fwr_destination_ranges      = null
      fwr_source_tags             = null
      fwr_source_service_accounts = null
      fwr_target_tags             = var.fwr_two_tags
      fwr_target_service_accounts = null
      fwr_priority                = var.fwr_two_priority
      fwr_direction               = var.fwr_two_direction

      # Allow List
      allow = [{
        protocol = var.fwr_two_rule1_protocol
        ports    = var.fwr_two_rule1_ports
      }]

      # Deny List
      deny = []

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

    }
  ]

  ## Firewall depends on existence of Network
  # depends_on = [ module.la_vpc_internal.vpc_network_name ]
}


# Module: Google Compute Engine
module "la_gce_external" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gce_instance/stable/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name            = var.gce_two_name
  gce_metadata        = var.gce_two_metadata
  gce_startup_script  = "${file("./scripts/lab-init.sh")}"
  gce_machine_type    = var.gce_two_machine_type
  gce_tags            = var.gce_two_tags
  gce_machine_image   = var.gce_two_machine_image
  gce_machine_network = module.la_vpc_external.vpc_subnetwork_name # "default" || google_compute_subnetwork.dev_subnet.name
  gce_scopes          = var.gce_two_scopes
  gce_service_account = var.gce_two_service_account
}
