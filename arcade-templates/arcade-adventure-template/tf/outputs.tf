## --------------------------------------------------------------
## Custom variable definitions
## --------------------------------------------------------------

# Terraform Output values
output "service_url" {
  value = module.la_cloud_run.gcr_service_url
}
 
output "gcp_storage_bucket" {
    value = module.la_gcs.gcs_bucket_name
}

output "lab_topic" {
    value = var.lab_topic
}

output "lab_context" {
    value = var.lab_context
}

output "lab_code" {
    value = var.lab_code
}

output "arcade_data" {
      value = local.arcade_base64
}
