output "bucket_name" {
  value       = "${google_storage_bucket.bucket.name}"
  description = "The name of the storage bucket created through the startup-script."
}
output "new_lab_title" {
  value       = "Qwiklabs Demo Lab 6 - ${random_string.startup_labtitle.id}"
  description = "Lab title genrated randomly through the startup-script."
}
