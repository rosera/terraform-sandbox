// Status variable
resource "random_shuffle" "status" {
  input        = ["copied","completed","done"]
  result_count = 1
}

output "status_variable" {
  value       = random_shuffle.status.result[0]
  description = "The name of the status variable."
}

// Random string example
resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

output "gcp_zone" {
  value =var.gcp_zone
  description = "The lab GCP Zone assigned for the project"
}

output "gcp_region" {
  value =var.gcp_region
  description = "The lab GCP Region assigned for the project"
}

output "gcp_project_id" {
  value =var.gcp_project_id
  description = "The lab GCP Project_ID assigned for the project"
}