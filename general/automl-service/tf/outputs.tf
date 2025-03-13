## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

output "notebook_service_url" {
  value       = module.la_vertex_workbench.notebook_service_url
  description = "URL of the Vertex notebook service"
}

output "automl_service_url" {
  value       = module.la_automl_proxy.service_url
  description = "URL of the AutoML Proxy service"
}
