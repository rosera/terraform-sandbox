# Module: API Service 
# Remote: github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev

module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "bigqueryconnection.googleapis.com" ] 
}

# Module: Lab Project
# Remote: github.com/CloudVLab/terraform-lab-foundation//basics/lab_project/stable

module "la_project" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/lab_project/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
}

# Module: Google Cloud Storage
# Remote: github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable

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

# Module: CloudBuild Script 
# Remote: github.com/CloudVLab/terraform-lab-foundation//solutions/cloudbuild_script/stable

module "cloudbuild_script" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
  create_cmd_body = "${var.gcp_project_id}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file
}

# Module: Vertex AI Notebook 
# Remote: github.com/CloudVLab/terraform-lab-foundation//basics/vai_notebook/stable

module "la_vai_notebook" {
  ## REMOTE: GitHub (Public) access - working
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_notebook/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## Custom Properties
  # vai_notebook_name = "custom-notebook-name"
  vai_region        = var.gcp_region
  vai_zone          = var.gcp_zone

  vai_image_family  = "tf-2-8-cu113-notebooks-debian-10"
}
