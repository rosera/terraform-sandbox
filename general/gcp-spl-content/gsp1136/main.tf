# Module: GoogleAPIs 
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "firebase.googleapis.com", "firestore.googleapis.com", "firebaserules.googleapis.com" ] 
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

resource "time_sleep" "wait_60_seconds" {
    create_duration = "60s"
    depends_on = [ google_firebase_web_app.basic ]
    # depends_on = [ module.la_api_batch ]
    # depends_on = [google_project.project]
}


## https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/firestore_database
resource "google_firestore_database" "database" {
  provider                    = google-beta
  project                     = var.gcp_project_id 
  name                        = "lab-demo"
  location_id                 = "nam5"
  type                        = "FIRESTORE_NATIVE"
  concurrency_mode            = "OPTIMISTIC"
  app_engine_integration_mode = "DISABLED"

  depends_on = [ time_sleep.wait_60_seconds ] 
}

# Module: App Engine + Cloud Firestore
## module "la_gae_database" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/app_engine/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   # Customise the GAE instance
##   gae_location    = "us-central" 
##   gae_hasDatabase = true 
##   gae_db_type     = "CLOUD_FIRESTORE"
## }

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

  # depends_on = [ google_firestore_database.database ] 
}

# Module: Google Compute Engine
module "la_gce" {
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gce_instance/stable/v1"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name            = "firebase-vm" 
  gce_machine_network = "default" 
  # gce_metadata = ["${file("./scripts/startup-script.sh")}"]
  gce_metadata         = {
    startup-script = <<EOF
      #!/bin/bash
      # STARTUP-START
      # Set environment variables
      export USER="nix-dev"
      export HOME="/home/$USER"

      # Create a user
      useradd $USER -m -p Password01 -s /bin/bash -c "$USER Developer Account"

      # Install Nix package manager - Ensure $USER + $HOME env var are defined
      sh <(curl -L https://nixos.org/nix/install) --daemon --yes

      # Install required application packages
      /nix/var/nix/profiles/default/bin/nix-env -iA nixpkgs.nodejs_22 nixpkgs.firebase-tools nixpkgs.cacert
      # nix-env -iA nixpkgs.nodejs_22 nixpkgs.firebase-tools nixpkgs.cacert
      # STARTUP-END
    EOF
  } 

  gce_startup_script  = null
  # gce_startup_script   = "${file("./scripts/lab-init.sh")}"

  ## Overrides
  gce_machine_type    = "e2-medium" 
  gce_tags            = ["lab-vm"] 
  gce_machine_image   = "debian-cloud/debian-11" 
  gce_scopes          = ["cloud-platform"] 
  gce_service_account = "default"
  #gce_machine_network = google_compute_subnetwork.dev_subnet.name
}
