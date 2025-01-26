## --------------------------------------------------------------
## Output variable definitions - Override from Custom Properties
## --------------------------------------------------------------

output "workbench_proxy_uri" {
  value       = "${module.la_vai_workbench.workbench_proxy_uri}" 
  description = "URI for the Vertex AI Workbench"
}

output "workbench_name" {
  value       = "${module.la_vai_workbench.workbench_name}"
  description = "Vertex Workbench name"
}
