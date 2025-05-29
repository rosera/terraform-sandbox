module "la_vpc" {
  ## REMOTE: GitHub (Public) access - working
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_network/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the VPC 
  vpc_network             = "dev-network"
  vpc_network_description = "Developer network"
  vpc_subnet              = "dev-subnetwork"
  vpc_region              = var.gcp_region 
  vpc_subnet_cidr         = "10.1.0.0/24"
}
