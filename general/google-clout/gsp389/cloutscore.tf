// Create a public storage bucket that the default Compute Engine
// Service account can write to and copy in the clout_output.html file
resource "google_storage_bucket" "lab_bucket" {
  name                        = var.gcp_project_id
  location                    = var.gcp_region
  force_destroy               = true
  uniform_bucket_level_access = true
}

data "google_compute_default_service_account" "default" {
}

data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${data.google_compute_default_service_account.default.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "viewer" {
  bucket      = google_storage_bucket.lab_bucket.name
  policy_data = data.google_iam_policy.viewer.policy_data
}

resource "google_storage_bucket_object" "html_score" {
  name          = "clout_submit.html"
  source        = "data/clout_submit.html"
  bucket        = google_storage_bucket.lab_bucket.name
  cache_control = "no-cache, max-age=0"
}

resource "google_storage_bucket_object" "js_score" {
  name          = "clout_score.js"
  source        = "data/clout_score.js"
  bucket        = google_storage_bucket.lab_bucket.name
  cache_control = "no-cache, max-age=0"
}

resource "google_storage_bucket_object" "clout_copy" {
  name          = "clout_copy.png"
  source        = "data/clout_copy.png"
  bucket        = google_storage_bucket.lab_bucket.name
  cache_control = "no-cache, max-age=0"
}

resource "google_storage_bucket_object" "clout_linkedin" {
  name          = "clout_linkedin.png"
  source        = "data/clout_linkedin.png"
  bucket        = google_storage_bucket.lab_bucket.name
  cache_control = "no-cache, max-age=0"
}

resource "google_storage_bucket_object" "clout_tweet" {
  name          = "clout_tweet.png"
  source        = "data/clout_tweet.png"
  bucket        = google_storage_bucket.lab_bucket.name
  cache_control = "no-cache, max-age=0"
}


// outputs

// Output variable for the Clout Score - assumes it is written to specific bucket
// created using the project_id as the bucket name
output "share_msg_url" {
  value = "https://storage.googleapis.com/${var.gcp_project_id}/clout_submit.html"
}

