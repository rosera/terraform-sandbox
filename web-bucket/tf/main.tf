
# Data: Google Cloud Project
data "google_project" "project" {
     project_id = var.gcp_project_id
}

# Locals: CloudBuild Service Account template variable
locals {
  # PROJECT_NUMBER@cloudbuild.gserviceaccount.com
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

module "la_sa_role" {
   source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

   ## Exchange values between Qwiklabs and Module
   gcp_project_id = var.gcp_project_id
   gcp_region     = var.gcp_region 
   gcp_zone       = var.gcp_zone 

   ## Custom Properties
   # Pass the service account as principal member - non authoritative binding
   iam_sa_name  = local.service_account
   iam_sa_roles = ["roles/storage.admin"]
}

# Module: Google Cloud Storage
module "la_gcs" {
  ## NOTE: When changing the source parameter, `terraform init` is required

  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  #source = "./basics/gcs_bucket/stable"

  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  gcs_bucket_extension = "bucket" 
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true 
}

# Solution: CloudBuild Script 
# Remote: github.com/CloudVLab/terraform-lab-foundation//solutions/cloudbuild_script/stable

module "cloudbuild_script" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
  # Parameters to supply to the script - $1:PROJECT_ID, $2:BUCKET_NAME
  create_cmd_body = "${var.gcp_project_id} ${var.gcp_project_id}-bucket"
  # create_cmd_body = "${var.gcp_project_id}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file

  # Ensure the bucket name is available
  # depends_on = [ module.la_gcs.gcs_bucket_name ]
}
