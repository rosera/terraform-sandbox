# Module: GoogleAPIs 
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Enable Google API(s)
  api_services = [ "firebase.googleapis.com" ] 
}

resource "google_firebase_project" "default" {
    provider = google-beta
    project  = var.gcp_project_id 
    depends_on = [ module.la_api_batch ]
}

resource "google_firebase_web_app" "basic" {
    provider = google-beta
    project  = var.gcp_project_id 
    display_name = "Display Name Basic"
    deletion_policy = "DELETE"

    depends_on = [google_firebase_project.default]
}

data "google_firebase_web_app_config" "basic" {
  provider   = google-beta
  project  = var.gcp_project_id 
  web_app_id = google_firebase_web_app.basic.app_id
}

resource "google_storage_bucket" "default" {
    provider = google-beta
    project  = var.gcp_project_id 
    name     = "${var.gcp_project_id}-fb-webapp"
    location = "US"
}

## https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/firebase_web_app
resource "google_storage_bucket_object" "default" {
    provider = google-beta
    bucket   = google_storage_bucket.default.name
    name     = "firebase-config.json"

    content = jsonencode({
        appId              = google_firebase_web_app.basic.app_id
        apiKey             = data.google_firebase_web_app_config.basic.api_key
        authDomain         = data.google_firebase_web_app_config.basic.auth_domain
        databaseURL        = lookup(data.google_firebase_web_app_config.basic, "database_url", "")
        storageBucket      = lookup(data.google_firebase_web_app_config.basic, "storage_bucket", "")
        messagingSenderId  = lookup(data.google_firebase_web_app_config.basic, "messaging_sender_id", "")
        measurementId      = lookup(data.google_firebase_web_app_config.basic, "measurement_id", "")
    })
}


locals {
  ## File: .firebaserc 
  project_config = {
    "projects": {
      "default": "${var.gcp_project_id}"
    }
  }

  ## File: firebase.json 
  hosting_config = {
    "hosting": {
      "public": "web",
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ]
    }
  }
}

## https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/firebase_web_app
resource "google_storage_bucket_object" "rc" {
    provider = google-beta
    bucket   = google_storage_bucket.default.name
    name     = ".firebaserc"

    content = jsonencode(local.project_config)
}

## https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/firebase_web_app
resource "google_storage_bucket_object" "json" {
    provider = google-beta
    bucket   = google_storage_bucket.default.name
    name     = "firebase.json"

    content = jsonencode(local.hosting_config)
}


## TODO:
## Setup a CloudBuild Script to deploy to Firebase Hosting + Cloud Functions

# Data: Google Cloud Project
data "google_project" "project" {
   project_id = var.gcp_project_id
}

# Locals: CloudBuild Service Account template variable
locals {
   #  PROJECT_NUMBER@cloudbuild.gserviceaccount.com
   service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

## # Module: Bind named Service Account with IAM role(s)
## module "la_sa_role" {
##    source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"
## 
##    ## Exchange values between Qwiklabs and Module
##    gcp_project_id = var.gcp_project_id
##    gcp_region     = var.gcp_region 
##    gcp_zone       = var.gcp_zone 
## 
##    ## Custom Properties
##    # Pass the service account as principal member - non authoritative binding
##    iam_sa_name  = local.service_account
##    iam_sa_roles = ["roles/firebase.admin"]
## }
## 
## # Module: Invoke CloudBuild script 
## module "cloudbuild_script" {
##  source = "terraform-google-modules/gcloud/google"
##  version = "~> 3.0.1"
##  platform = "linux"
##  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
##  create_cmd_body = "${var.gcp_project_id}"
##  skip_download = false
##  upgrade = false
##  gcloud_sdk_version = "358.0.0"
##  service_account_key_file = var.service_account_key_file
## }
