## Expose Project properties

# Terraform Output values
output "project_id" {
  value = module.la_project.gcp_project_id
}
output "project_number" {
  value = module.la_project.gcp_project_number
}
output "project_region" {
  value = module.la_project.gcp_project_region
}
output "project_zone" {
  value = module.la_project.gcp_project_zone
}
output "random_city" {
  value = random_shuffle.city.result[0]
}
output "random_event" {
  value = random_shuffle.event.result[0]
}
output "random_pilot" {
  value = random_shuffle.pilot.result[0]
}