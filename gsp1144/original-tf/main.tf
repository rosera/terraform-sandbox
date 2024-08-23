# Cloud Functions:   
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Cloud Functions
module "la_gcf" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/stable"

  # Pass values to the module
  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  gcp_zone             = var.gcp_zone

  # Customise the Cloud Storage
  gcs_bucket_extension = "bucket"

  # Customise the Cloud Function
  gcf_name                  = "sensor-data-generator"
  gcf_description           = "Definining a new function"
  gcf_runtime               = "python39"
  gcf_target_bucket         = "mybucket"
  gcf_archive_source        = "./cf/main.zip"
  gcf_entry_point           = "hello_world"
  gcf_environment_variables = {
    PROJECT_ID = var.gcp_project_id
#    BUCKETNAME = "${var.gcp.project_id}-bucket" 
#    FILENAME   = "tasks.json"
  }
}

resource "google_pubsub_topic" "weather_sensor_trigger" {
  name = "weather-sensor-trigger"
}


## resource "google_project_service_identity" "functions_default_sa" {
##   provider = google-beta
## 
##   project = var.gcp_project_id
##   service = "cloudfunctions.googleapis.com"
## }
## 
## resource "google_project_service" "compute_api" {
##   service            = "compute.googleapis.com"
##   disable_on_destroy = false
## }
## 
## data "google_compute_default_service_account" "gce_default" {
##   depends_on = [
##     google_project_service.compute_api
##   ]
## }
## resource "google_project_service" "functions_api" {
##   service            = "cloudfunctions.googleapis.com"
##   disable_on_destroy = false
## }
## 
## resource "google_project_service" "iam_api" {
##   service            = "iam.googleapis.com"
##   disable_on_destroy = false
## }
## 
## 
## resource "google_project_iam_member" "functions_default_iam" {
##   project = var.gcp_project_id
##   for_each = toset([
##     "roles/cloudfunctions.serviceAgent"
##   ])
##   role   = each.key
##   member = "serviceAccount:${google_project_service_identity.functions_default_sa.email}"
##   depends_on = [
##     google_project_service.functions_api,
##     google_project_service.iam_api
##   ]
## }
## 
## resource "time_sleep" "wait_until_functions_sa_ready" {
##   create_duration = "90s"
##   depends_on = [
##     google_project_iam_member.functions_default_iam
##   ]
## }
## 
## resource "random_id" "bucket_prefix" {
##   byte_length = 8
## }
## 
## resource "google_storage_bucket" "bucket" {
##   name     = "${random_id.bucket_prefix.hex}-code-bucket"
##   location = "US"
##   uniform_bucket_level_access = true
## }
## 
## resource "google_storage_bucket_object" "archive" {
##   name   = "main.zip"
##   bucket = google_storage_bucket.bucket.name
##   source = "./main.zip"
## }
## 
## resource "google_pubsub_topic" "weather_sensor_trigger" {
##   name = "weather-sensor-trigger"
## }
## 
## resource "google_cloudfunctions_function" "sensor_data_generator" {
##   name        = "sensor-data-generator"
##   description = "defining a new function"
##   runtime     = "python39"
## 
##   available_memory_mb   = 512
##   source_archive_bucket = google_storage_bucket.bucket.name
##   source_archive_object = google_storage_bucket_object.archive.name
##   trigger_http          = true
##   entry_point           = "hello_world"
##   timeout               = 540
##   https_trigger_security_level = "SECURE_OPTIONAL"
## 
##   service_account_email = data.google_compute_default_service_account.gce_default.email
## 
##   environment_variables = {
##     PROJECT_ID = var.gcp_project_id
##   }
## 
##   depends_on = [
##     time_sleep.wait_until_functions_sa_ready
##   ]
## }
## 
## resource "google_cloudfunctions_function_iam_member" "invoker" {
##   project        = google_cloudfunctions_function.sensor_data_generator.project
##   region         = google_cloudfunctions_function.sensor_data_generator.region
##   cloud_function = google_cloudfunctions_function.sensor_data_generator.name
## 
##   role   = "roles/cloudfunctions.invoker"
##   member = "allUsers"
## }
