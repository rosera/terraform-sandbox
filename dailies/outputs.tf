## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

output "project_id" {
  value = var.gcp_project_id
}

output "gcp_zone" {
  value = var.gcp_zone
}

output "Bucket" {
  value = "${var.gcp_project_id}-bucket"
}