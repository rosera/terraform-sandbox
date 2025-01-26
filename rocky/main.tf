# ------------------ IDE: Integrated Development Environment
# ------------------ Module Definition
#

# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Solution: IDE environment
# Local:  modules/stable
# Remote: github.com/CloudVLab/terraform-lab-foundation//solutions/ide_web/stable

# Output Value(s):
# - ideEditorService  : URL of IDE Service
# - ideBrowserService : URL of Browser Service
# - ideInstanceName   : URL of Browser Service

module "la_ide" {
  ## NOTE: When changing the `source` parameter
  ## `terraform init` is required

  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  ## source = "./solutions/ide_web/stable"

  ## REMOTE: GitHub (Public) access - working
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/ide_web/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id  = var.gcp_project_id
  gcp_region      = var.gcp_region
  gcp_zone        = var.gcp_zone
  gcp_username    = var.tfUsername

  ## Properties: GCE
  # gceMachineImage  = var.tfMachineImage
  gceMachineImage    = "crypto-codeserver"
  # gceInstanceName  = "cloudlearningservices"
  # gceInstanceZone  = "us-central1-f"
  # gceInstanceTags  = ["lab-vm"]
  # gceMachineType   = "e2-standard-2"
  # gceInstanceScope = ["cloud-platform"]

  ## Properties: Cloud Run
  # gcrRegion        = "us-central1"
}
  resource "google_compute_firewall" "vm-activity-tracking-ssh" {
  name    = "rule-for-at-ssh"
  network = "dev-network"
  direction = "INGRESS"
  project = var.gcp_project_id

  # Enable INGRESS
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [ module.la_ide ]
}
