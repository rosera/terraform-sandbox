## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

# Terraform Output values
output "service_url" {
  value = module.la_cloud_run.gcr_service_url
}

output "lab_item" {
  value = local.random_item
}

output "lab_list" {
  value = local.random_list
}

output "lab_topic" {
  value = local.lab_topic
}
