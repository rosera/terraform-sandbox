# Module: Google Cloud Storage
module "la_gcs" {

  ## REMOTE: GitHub (Public) access - working
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  gcs_bucket_extension = "bucket"
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true
}

resource "google_storage_bucket_object" "index-file" {
  name   = "index.html"
  source = "scripts/index.html"
  bucket = module.la_gcs.gcs_bucket_name
  depends_on = [module.la_gcs]
}

resource "google_storage_bucket_object" "error-file" {
  name   = "error.html"
  source = "scripts/error.html"
  bucket = module.la_gcs.gcs_bucket_name
  depends_on = [module.la_gcs]
}

resource "google_storage_bucket_object" "css-file" {
  name   = "style.css"
  source = "scripts/style.css"
  bucket = module.la_gcs.gcs_bucket_name
  depends_on = [module.la_gcs]
}

resource "google_storage_bucket_object" "google-logo" {
  name   = "logo.png"
  source = "scripts/logo.png"
  bucket = module.la_gcs.gcs_bucket_name
  depends_on = [module.la_gcs]
}

# Override existing policy with least privilege SA new policy

data "google_project" "project" {
  project_id = var.gcp_project_id
}

resource "google_project_iam_policy" "project_policy" {
  project     = "${var.gcp_project_id}"
  policy_data = data.google_iam_policy.new_policy.policy_data
  depends_on = [google_storage_bucket_object.google-logo]
}

data "google_iam_policy" "new_policy" {
  binding {
    role = "roles/editor"
    members = [
      "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
    ]
  }
  binding {
    role = "roles/owner"
    members = [
      "serviceAccount:admiral@qwiklabs-services-prod.iam.gserviceaccount.com"
    ]
  }
  binding {
    role = "roles/storage.admin"
    members = [
     "user:${var.username}@qwiklabs.net",
     "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
    ]
  }
  binding {
    role = "roles/viewer"
    members = [
     "user:${var.username}@qwiklabs.net",
     "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
    ]
  }
  depends_on = [google_storage_bucket_object.google-logo]
}