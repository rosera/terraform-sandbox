# Module: Google Kubernetes Engine - Autopilot 
module "la_gke_autopilot" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/gke_autopilot/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GKE cluster 
  gkeIsCustomNetwork  = var.isCustomNetwork 
  gkeClusterName      = var.gkeClusterName 
  gkeDescription      = var.gkeClusterDescription 
  gkeNetwork          = module.la_vpc.vpc_network_name
  gkeSubnetwork       = module.la_vpc.vpc_subnetwork_name
  # gkeNetwork          = "default"
  # gkeSubnetwork       = "default"
}
