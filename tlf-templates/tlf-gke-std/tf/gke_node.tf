# Module: Google Kubernetes Engine - COS_CONTAINERD Node Pool
module "la_gke_np_cos" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/gke_node_pool/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GKE cluster
  gkeClusterName      = module.la_gke_std.gkeClusterName
  gkeMachineType      = "e2-standard-4"
  gkeImageType        = "COS_CONTAINERD"
  gkeInitialNodeCount = 1
}
