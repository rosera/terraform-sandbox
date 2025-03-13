## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

output "ideServiceUrl" {
  value = module.la_cloud_run.service_url
  description = "URL of the IDE service"
}

output "webServiceUrl" {
  value = module.la_cloud_run_browser.service_url
  description = "URL of the IDE service"
}

output "hostName" {
  value       = "${var.gceInstanceName}"
  description = "Name of the GCE instance"
}

output "hostExternalIp" {
  value       = "${module.la_gce.gce_external_ip}"
  description = "External IP address of GCE instance"
}

output "hostPort" {
  value       = "8000"
  description = "Wagtail default address"
}

