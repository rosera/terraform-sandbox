module "la_vai_workbench" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_workbench/stable/v1"
  ## source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vai_workbench/stable"
  ## source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vai_workbench/stable/v1"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  vai_machine_network     = module.la_vpc.vpc_network_self_link
  vai_machine_subnet      = module.la_vpc.vpc_subnet_self_link
  vai_post_startup_script = "https://storage.googleapis.com/spls/tlf-workbench/proxy-lab-init.sh"
  # vai_post_startup_script = "gs://[bucket]/[LAB_ID]/lab-init.sh"
  
  # vai_notebook_name = "custom-notebook-name" 
  depends_on    = [ module.la_api_batch.wait_api_delay ]
}
