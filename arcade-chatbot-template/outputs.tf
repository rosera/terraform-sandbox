## --------------------------------------------------------------
## Custom variable definitions
## --------------------------------------------------------------

# Terraform Output values
output "service_url" {
  value = module.la_cloud_run.gcr_service_url
}
 
output "lab_topic" {
    value = local.lab_topic
}

output "lab_persona" {
    value = local.lab_persona
}

output "lab_context" {
    value = local.lab_context
}

output "lab_item" {
    value = local.random_item 
}

output "lab_list" {
    value = local.random_list 
}

output "gcp_storage_bucket" {
    value = module.la_gcs.gcs_bucket_name
}
