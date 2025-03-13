## Expose GCE properties

output "gcp_region" {
  value = var.gcp_region
}

output "gcp_zone" {
  value = var.gcp_zone
}

resource "random_shuffle" "service_name" {
  input        = ["producer-service", "gcc-producer-service", "demo-producer-service", "cymbal-producer-service"]
  result_count = 1
}

output "psc_service" {
  value       = "${random_shuffle.service_name.result[0]}"
  description = "Name of the psc service."
}

resource "random_shuffle" "ilb_prefix" {
  input        = ["gcc-forntend-lb", "gcc-frontend", "frontend-gcc", "cymbal-frontend"]
  result_count = 1
}

output "ilb" {
  value       = "${random_shuffle.ilb_prefix.result[0]}"
  description = "Name of the load balancer."
}

resource "random_shuffle" "ip_address" {
  input        = ["10.0.80.100","10.0.80.101","10.0.80.102"]
  result_count = 1
}

output "ip" {
  value       = "${random_shuffle.ip_address.result[0]}"
  description = "IP address of ILB."
}
