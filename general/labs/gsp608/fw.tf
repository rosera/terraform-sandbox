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
