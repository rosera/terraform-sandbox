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
    bucket = google_storage_bucket.default.name
    name = "firebase-config.json"

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
