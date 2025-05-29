# GKE:    Google Kubernetes Engine 
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Google Kubernetes Engine - Standard
module "la_gke_std" {
  #source = "github.com/CloudVLab/terraform-lab-foundation//basics/gke_standard/dev"
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/gke_standard/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gke_standard/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GKE cluster 
  gkeClusterName      = "my-cluster"
  gkeDescription      = "Lab Kubernetes Cluster"
  gkeNetwork          = "default"
  gkeSubnetwork       = "default"
  gkeIsCustomNetwork  = false
  gkeInitialNodeCount = 1
  ## gkeRemoveDefaultNodePool set to false if Windows Node Pool used 
  # gkeRemoveDefaultNodePool = false
  # gkeMachineType = "e2-standard-4"
  ## gkeImageType set as "COS_CONTAINERD" or "UBUNTU_CONTAINERD" or WINDOWS_LTSC_CONTAINERD
  # gkeImageType        = "WINDOWS_LTSC_CONTAINERD"
  # gkeImageType        = "UBUNTU_CONTAINERD"
  # gkeImageType        = "COS_CONTAINERD"
}
