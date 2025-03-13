## Expose Project properties

output "bucket_name" {
  value = module.la_gcs.gcs_bucket_name
  description = "Name of the Google Storage bucket"
}

output "bucket_file" {
  value = google_storage_bucket_object.task_object.name 
  description = "Name of the Google Storage Object file"
}
