## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

output "workbench_service_url" {
  value       = module.la_vertex_workbench.workbench_service_url
  description = "URL of the Vertex Workbench service"
}
