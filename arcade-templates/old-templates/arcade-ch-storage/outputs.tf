## Expose Project properties
## --------------------------------------------------------------
output "time1" {
  value = local.random_time1 
}

output "time2" {
  value = local.random_time2
}

output "weekday" {
  value = local.random_weekday
}

output "requestor" {
  value = local.random_requestor
}

output "requestor_role" {
  value = local.random_role
}

output "task" {
  value = local.random_task
}

output "product" {
  value = local.random_product
}

output "stakeholder_name" {
  value = local.random_stakeholder_name
}

output "stakeholder_role" {
  value = local.random_stakeholder_role
}

output "duration" {
  value = local.random_duration 
}

output "bucket_name" {
  value = local.random_bucket_name 
}

output "test_filename" {
  value = local.random_test_filename 
}
