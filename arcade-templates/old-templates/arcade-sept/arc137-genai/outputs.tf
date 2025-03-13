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

# -----------------------------------------------------------------------------
# Question Bank
# -----------------------------------------------------------------------------

output "question_1" {
    value = "Hello what is your name?" 
}

output "question_2" {
    value = "What can you tell me about ${var.lab_topic}?"
}

output "question_3" {
    value = "Who is ${local.lab_persona}?"
}

output "question_4" {
    value = "What can you tell me about ${local.random_item}?"
}

output "question_5" {
    value = local.lab_list[0]
}

output "question_6" {
    value = local.lab_list[1]
}

output "question_7" {
    value = local.lab_list[2]
}

output "question_8" {
    value = local.lab_list[3]
}
