## Expose Terraform resource properties
## Startup Script Variables
## --------------------------------------------------------------

## GETTER: region.address
output "proj1_region_id" {
  value = "${var.gcp_project_id}-${var.gcp_region}"
}

output "proj1_static_ip" {
  value = var.psc_sql_ip
}
