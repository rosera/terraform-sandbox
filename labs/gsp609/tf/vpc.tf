# Module: Virtual Private Cloud
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

module "la_vpc" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_network/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vpc_network/stable"

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
