#
# ------------------ Module Definition 
#

# Solution: IDE environment 
# Local:  modules/tf
# Remote: github//TBC
# Output Value(s):
# - ideEditorService  : URL of IDE Service
# - ideInstanceName   : URL of Browser Service

module "la_ide" {
  ## NOTE: When changing the `source` parameter
  ## `terraform init` is required

  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  # source = "./solutions/ide_cloud_code/stable"

  ## REMOTE: GitHub (Public) access - working
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/ide_cloud_code/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id   = var.gcp_project_id
  gcp_region       = var.gcp_region
  gcp_zone         = var.gcp_zone

  ## Custom Bools for GKE Security
  isPrivateCluster = false
  isCustomNetwork  = false

  gceMachineImage  = "cloud-code-codeserver"
  gceInstanceZone  = var.gcp_zone

  ## Properties: Cloud Run
  gcrRegion        = var.gcp_region

  ## Properties: GKE 
  gkeRegion        = var.gcp_region
}
