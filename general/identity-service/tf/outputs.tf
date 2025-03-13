output "full_notebook_name" {
    value = local.full_notebook_name
}

output "notebook_name" {
    value = var.notebook_name
}

output "notebook_version" {
    value = var.notebook_version
}

output "workbench_name" {
    value = var.workbench_name
}

output "service_account_member" {
  value = module.la_identity_service.service_account_emails
}
