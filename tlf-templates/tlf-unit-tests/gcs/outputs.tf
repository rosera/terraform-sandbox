#------------------------------------------------------------------------------
# Unit Test 

## unit_testx_name
output "unit_test1_name" {
  value = var.unit_test1_name 
}

## unit_testx_task
output "unit_test1_task" {
  value = var.unit_test1_task 
}

#------------------------------------------------------------------------------
# Startup Script Values 

output "gcs_bucket1_name" {
  description = "Name of the Cloud Storage Bucket"
  value       = module.la_gcs_private.gcs_bucket_name
}

output "gcs_bucket2_name" {
  description = "Name of the Cloud Storage Bucket"
  value       = module.la_gcs_public.gcs_bucket_name
}
