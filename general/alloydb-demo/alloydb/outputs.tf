## Expose Resource properties
output "gcp_alloydb_password" {
  value       = "${var.alloydb_password}"
  description = "Alloydb password for cluster"
}
