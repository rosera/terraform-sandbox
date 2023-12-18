# Module: GoogleAPIs 
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Enable Google API(s)
  api_services   = [ "firebase.googleapis.com", "run.googleapis.com", "eventarc.googleapis.com", "pubsub.googleapis.com", "cloudfunctions.googleapis.com", "cloudbuild.googleapis.com", "storage.googleapis.com", "artifactregistry.googleapis.com" ] 
}

resource "google_firebase_project" "default" {
    provider   = google-beta
    project    = var.gcp_project_id 
    depends_on = [ module.la_api_batch ]
}

resource "google_firebase_web_app" "basic" {
    provider        = google-beta
    project         = var.gcp_project_id 
    display_name    = "Display Name Basic"
    deletion_policy = "DELETE"

    depends_on = [google_firebase_project.default]
}

data "google_firebase_web_app_config" "basic" {
  provider   = google-beta
  project    = var.gcp_project_id 
  web_app_id = google_firebase_web_app.basic.app_id
}

resource "google_storage_bucket" "fb_default" {
    provider = google-beta
    project  = var.gcp_project_id 
    name     = "${var.gcp_project_id}-fb-webapp"
    location = "US"
}

resource "google_storage_bucket" "gcp_default" {
    provider = google-beta
    project  = var.gcp_project_id 
    name     = "${var.gcp_project_id}-bucket"
    location = "US"
}

## https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/firebase_web_app
resource "google_storage_bucket_object" "default" {
    provider = google-beta
    bucket   = google_storage_bucket.fb_default.name
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

## Create the Firebase configuration files
locals {
  ## File: .firebaserc 
  project_config = {
    "projects": {
      "default": "${var.gcp_project_id}"
    }
  }

  ## File: firebase.json - Hosting
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

  ## File: firebase.json - Hosting + Cloud Functions
  firebase_config = {
    "functions": [
      {
        "codebase": "default",
        "ignore": [
          "node_modules",
          ".git",
          "firebase-debug.log",
          "firebase-debug.*.log"
        ],
        "source": "functions"
      }
    ],
    "hosting": {
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ],
      "public": "web"
    }
  }
}

## https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/firebase_web_app
resource "google_storage_bucket_object" "rc" {
    provider = google-beta
    bucket   = google_storage_bucket.fb_default.name
    name     = ".firebaserc"
    content  = jsonencode(local.project_config)
}

## https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/firebase_web_app
resource "google_storage_bucket_object" "json" {
    provider = google-beta
    bucket   = google_storage_bucket.fb_default.name
    name     = "firebase.json"
    content  = jsonencode(local.firebase_config)
}

#-----------------------------------------------------------------------------
# Module: Cloud Functions
module "la_gcf" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_function/stable"

  # Pass values to the module
  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  gcp_zone             = var.gcp_zone

  # Customise the Cloud Storage
  gcs_bucket_extension = "arcade"

  # Customise the Cloud Function
  gcf_name             = "arcade-1"
  gcf_description      = "Arcade Game Endpoint"
  gcf_runtime          = "nodejs16"
  gcf_target_bucket    = "mybucket"
  gcf_archive_source   = "./cf/function.zip"
  gcf_entry_point      = "createStorageFile"
  gcf_environment_variables = {
    PROJECT_ID = var.gcp_project_id
    BUCKETNAME = "${var.gcp_project_id}-bucket" 
    FILENAME   = "arcade.txt"
    CONTENT    = "arcade"
  }
}



#-----------------------------------------------------------------------------
## TODO:
## Setup a CloudBuild Script to deploy to Firebase Hosting + Cloud Functions
## Setup a Compute Developer permissions 

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
module "la_sa_role" {
   source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

   ## Exchange values between Qwiklabs and Module
   gcp_project_id = var.gcp_project_id
   gcp_region     = var.gcp_region 
   gcp_zone       = var.gcp_zone 

   ## Custom Properties
   # Pass the service account as principal member - non authoritative binding
   iam_sa_name  = local.service_account
   iam_sa_roles = ["roles/firebase.admin"]
}


## TODO:
## Firebase Hosting - Web Application
## Firebase Cloud Functions - Chat/Bison-001 
## Firebase Cloud Functions - Cloud Storage

# Module: Invoke CloudBuild script 
module "cloudbuild_script" {
 source = "terraform-google-modules/gcloud/google"
 version = "~> 3.0.1"
 platform = "linux"
 create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
 create_cmd_body = "${var.gcp_project_id}"
 skip_download = false
 upgrade = false
 gcloud_sdk_version = "358.0.0"
 service_account_key_file = var.service_account_key_file
}
