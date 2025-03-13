## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

output "service_url" {
  value       = "${google_cloud_run_service.ide.status[0].url}"
  description = "URL of the IDE service"
}

# Name of the GCE Instance
output "ideInstanceName" {
  value       = "${google_compute_instance.gce_virtual_machine.name}"
  description = "Name of the GCE instance"
}

# Name of the VPC
output "ideVPC" {
  value       = "${module.la_vpc.vpc_network_name}"
  description = "Name of the VPC"
}

# Name of the Subnet
output "ideSubnet" {
  value       = "${module.la_vpc.vpc_subnetwork_name}"
  description = "Name of the Subnet"
}