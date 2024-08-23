# Module: Enable Google APIs
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "artifactregistry.googleapis.com" ] 
}

## resource "google_artifact_registry_repository" "my-repo" {
##   location      = var.gcp_region 
##   project       = var.gcp_project_id
##   repository_id = "gcf-artifacts"
##   description   = "AR Docker repository"
##   format        = "DOCKER"
## }

resource "google_pubsub_topic" "weather_sensor_trigger" {
  name    = "weather-sensor-trigger"
  project = var.gcp_project_id
}

## ## Function Identity: Gen1 + Gen2
## # Ref: https://cloud.google.com/functions/docs/securing/function-identity#runtime-sa
## locals {
##   # service_account = "serviceAccount:${module.la_sa.iam_service_account}@${var.gcp_project_id}.iam.gserviceaccount.com"
##   gen1_service_account = "serviceAccount:${var.gcp_project_id}@appspot.gserviceaccount.com"
##   # gen2_service_account = "serviceAccount:${PROJECT_NUMBER}-compute@$developer.gserviceaccount.com"
## }

## module "la_sa_role" {
##   ## REMOTE: GitHub (Public) access - working 
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"
## 
##   ## Exchange values between Qwiklabs and Module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region 
##   gcp_zone       = var.gcp_zone 
## 
##   ## Custom Properties
##   # Pass the service account as principle member - non authorative binding
##   # iam_sa_name  = local.service_account
##   iam_sa_name  = local.gen1_service_account
##   iam_sa_roles = ["roles/artifactregistry.reader", "roles/iam.serviceAccountUser"] 
## }

locals {
  cloud_function_object = "function.zip"
  cloud_function_path   = "./cf/"
}

# Cloud Functions:   
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Cloud Functions
module "la_gcf" {
  ## source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/stable"
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/dev"

  # Pass values to the module
  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  gcp_zone             = var.gcp_zone

  # Customise the Cloud Storage
  gcs_bucket_extension = "bucket"

  # Customise the Cloud Function
  gcf_name                  = "sensor-data-generator"
  gcf_description           = "Defining a new function"
  gcf_runtime               = "python39"
  gcf_target_bucket         = "mybucket"
  gcf_archive_source        = "${local.cloud_function_path}${local.cloud_function_object}"
  gcf_archive_object        = "${local.cloud_function_object}"
  gcf_entry_point           = "hello_world"
  gcf_registry              = "CONTAINER_REGISTRY"
  gcf_available_mb          = 512
  gcf_timeout               = 540 
  gcf_trigger_security      = "SECURE_OPTIONAL"
  gcf_environment_variables = {
    PROJECT_ID = var.gcp_project_id
  }
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
##   IS THIS CORRECT? GEN1 USES the APP ENGINE Service Account??
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
