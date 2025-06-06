module "la_fw" {
  ## NOTE: When changing the source parameter, `terraform init` is required

  ## REMOTE: GitHub (Public) access - working
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_firewall/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vpc_firewall/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## Ex: Default Network
  # fwr_network      = "default"
  ## Ex: Custom Network
  fwr_network      = module.la_vpc.vpc_network_name

  # Firewall Policy - Repeatable list of objects
  fwr_rules = [
    {
      fwr_name                    = "dev-allow-ssh"
      fwr_description             = "Firebase SSH access"
      fwr_source_ranges           = [ "0.0.0.0/0" ]
      fwr_destination_ranges      = null
      fwr_source_tags             = null
      fwr_source_service_accounts = null
      fwr_target_tags             = ["lab-vm"]
      fwr_target_service_accounts = null
      fwr_priority                = "1000"
      fwr_direction               = "INGRESS"

      # Allow List
      allow = [
        {
          protocol     = "tcp"
          ports        = [ "22" ]
        },
      ]

      # Deny List
      deny = []

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    }

  ]

  ## Firewall depends on existence of Network
  depends_on = [ module.la_vpc.vpc_network_name ]
}
