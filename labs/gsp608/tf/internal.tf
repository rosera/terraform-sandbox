# INTERNAL

# Module: Virtual Private Cloud 
module "la_vpc_internal" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_network/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vpc_network/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the VPC 
  vpc_network             = var.vpc_one_name
  vpc_network_description = var.vpc_one_name
  vpc_subnet              = "${var.vpc_one_name}-${var.gcp_region}"
  vpc_region              = var.gcp_region
  vpc_subnet_cidr         = var.vpc_one_cidr
}

# Module: Compute Firewall 
module "la_fw_internal" {
  ## REMOTE: GitHub (Public) access - working 
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_firewall/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vpc_firewall/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
  fwr_network    = module.la_vpc_internal.vpc_network_name

  # Firewall Policy - Repeatable list of objects
  fwr_rules = [
    {
      fwr_name                    = var.fwr_one_name
      fwr_description             = var.fwr_one_name
      fwr_source_ranges           = var.fwr_one_source_range
      fwr_destination_ranges      = null
      fwr_source_tags             = null
      fwr_source_service_accounts = null
      fwr_target_tags             = var.fwr_one_tags
      fwr_target_service_accounts = null
      fwr_priority                = var.fwr_one_priority
      fwr_direction               = var.fwr_one_direction

      # Allow List
      allow = [{
        protocol = var.fwr_one_rule1_protocol
        ports    = var.fwr_one_rule1_ports
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
module "la_gce_internal_a" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gce_instance/stable/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name            = var.gce_one_a_name
  gce_metadata        = var.gce_one_metadata
  gce_startup_script  = var.gce_one_startup_script # null || "${file("./scripts/lab-init.sh")}"
  gce_machine_type    = var.gce_one_machine_type
  gce_tags            = var.gce_one_tags
  gce_machine_image   = var.gce_one_machine_image
  gce_machine_network = module.la_vpc_internal.vpc_subnetwork_name # "default" || google_compute_subnetwork.dev_subnet.name
  gce_scopes          = var.gce_one_scopes
  gce_service_account = var.gce_one_service_account
}

# Module: Google Compute Engine
module "la_gce_internal_b" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gce_instance/stable/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name            = var.gce_one_b_name
  gce_metadata        = var.gce_one_metadata
  gce_startup_script  = var.gce_one_startup_script # null || "${file("./scripts/lab-init.sh")}"
  gce_machine_type    = var.gce_one_machine_type
  gce_tags            = var.gce_one_tags
  gce_machine_image   = var.gce_one_machine_image
  gce_machine_network = module.la_vpc_internal.vpc_subnetwork_name # "default" || google_compute_subnetwork.dev_subnet.name
  gce_scopes          = var.gce_one_scopes
  gce_service_account = var.gce_one_service_account
}
