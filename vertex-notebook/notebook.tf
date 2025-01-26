## // TF Modules
## module "la_gcs" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   # Customise the GCS instance
##   gcs_bucket_extension = "bucket" 
##   gcs_storage_class    = "STANDARD"
##   gcs_append_project   = true 
## }

module "la_vai_notebook" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_notebook/stable"
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_notebook/stable"
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_notebook/dev?ref=tlf_notebook"
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_notebook/dev"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # vai_machine_network = module.la_vpc.vpc_network_self_link
  # vai_machine_subnet  = module.la_vpc.vpc_subnet_self_link
  vai_notebook_name   = "ai-notebook" 
  vai_region          = var.gcp_region
  vai_zone            = var.gcp_zone
}

## // API Service module
## module "la_api_batch" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   # Customise the GCE instance
##   api_services = [ "iam.googleapis.com", "compute.googleapis.com", "containerregistry.googleapis.com", "aiplatform.googleapis.com", "cloudbuild.googleapis.com", "cloudfunctions.googleapis.com", "notebooks.googleapis.com" ] 
## }
## 
