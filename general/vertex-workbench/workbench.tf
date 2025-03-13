module "la_vai_workbench" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vai_workbench/stable/v1?ref=tlf-proxy"
  ## source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vai_workbench/stable"
  ## source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/vai_workbench/stable/v1"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # vai_notebook_name = "custom-notebook-name" 
  # vai_post_startup_script = "gs://[bucket]/[LAB_ID]/lab-init.sh"

   depends_on    = [ module.la_api_batch.wait_api_delay ]
}


## ## Google Cloud Workbench
## resource "google_workbench_instance" "instance" {
##   name = var.vai_workbench_name
##   ## location represents ZONAL 
##   location = var.gcp_zone
##   project  = var.gcp_project_id
## 
##   gce_setup {
##     ## Cannot use e2 with accelerator
##     machine_type = var.vai_machine_type
## 
##     dynamic "accelerator_configs" {
##       for_each = var.vai_accelerator_type != null ? [1] : []
##       content {
##         # Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/workbench_instance#type
##         type       = var.vai_accelerator_type
##         core_count = 1
##       }
##     }
##     
##     ##    accelerator_configs {
##     ##      type         = var.vai_accelerator_type 
##     ##      core_count   = 1
##     ##    }
## 
##     shielded_instance_config {
##       enable_secure_boot          = true
##       enable_vtpm                 = true
##       enable_integrity_monitoring = true
##     }
## 
##     ##    disable_public_ip = false
##     disable_public_ip = var.vai_disable_public_ip
## 
##     ##     service_accounts {
##     ##       email = "my@service-account.com"
##     ##     }
## 
##     ## SSD_TOTAL_GB: 500GB MAX
##     ## IMAGE SIZE: 150GB
##     boot_disk {
##       disk_size_gb = 200
##       disk_type    = "PD_SSD"
##       ##      disk_encryption = "CMEK"
##       ##      kms_key = "my-crypto-key"
##     }
## 
##     data_disks {
##       disk_size_gb = 100
##       disk_type    = "PD_SSD"
##       ##      disk_encryption = "CMEK"
##       ##      kms_key = "my-crypto-key"
##     }
## 
##     # TODO: Add the ability to have custom network
##     ##   network_interfaces {
##     ##     network = google_compute_network.my_network.id
##     ##     subnet = google_compute_subnetwork.my_subnetwork.id
##     ##     nic_type = "GVNIC"
##     ##   }
## 
##     dynamic "network_interfaces" {
##       for_each = var.vai_machine_network != null || var.vai_machine_subnet != null ? [1] : []
##       content {
##         network    = var.vai_machine_network
##         subnet     = var.vai_machine_subnet
##         nic_type   = var.vai_network_nic_type 
##         ## stack_type = var.vai_network_stack_type 
##       }
##     }
## 
##     ## Ref: https://cloud.google.com/vertex-ai/docs/workbench/instances/manage-metadata
##     metadata = {
##       ## post-startup-script = "https://storage.googleapis.com/spls/tlf-workbench/lab-init.sh"
##       post-startup-script = var.vai_post_startup_script
##     }
## 
##     ##    enable_ip_forwarding = true
##     enable_ip_forwarding = var.vai_enable_ip_forwarding
## 
##     tags = var.vai_tags
## 
##   }
## 
##   #  disable_proxy_access = "true"
##   #  disable_proxy_access = var.vai_disable_proxy_access
## 
##   ##  instance_owners  = [ "my@service-account.com"]
## 
##   ##   labels = {
##   ##     cls = "staging"
##   ##   }
## 
##   ##   desired_state = "ACTIVE"
## 
##   ## TODO: Move this functionality to parent caller
##   ## Give googleapis time to be created 
##   ## depends_on = [ time_sleep.wait_api_delay ]
##   depends_on    = [ module.la_api_batch.wait_api_delay ]
## }
