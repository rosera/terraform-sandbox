# ------------------ IDE: Integrated Development Environment   
# ------------------ Module Definition 
#

module "la_ide" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/ide_cloud_code/dev"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id       = var.gcp_project_id 
  gcp_region           = var.gcp_region 
  gcp_zone             = var.gcp_zone 

  ## Properties: GCE 
  gceMachineImage      = "cloud-code-codeserver" 

  ## GKE General 
  gkeClusterName        = "gke-intro"
  gkeLocation           = "us-central1-b"
  # gkeIsPrivateCluster = false 

  ## GKE Network - uses Default as Std
  # gkeIsCustomNetwork  = false 
  # gkeNetwork          = "default"
  # gkeSubnetwork       = "default"

  ## GKE Standard Settings
  gkeInitialNodeCount   = 3

  ## GKE Autopilot Settings 
  # gkeIsAutopilot      = true

}
