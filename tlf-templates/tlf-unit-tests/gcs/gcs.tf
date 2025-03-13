# Google Cloud Storage: Private
module "la_gcs_private" {
  ## REMOTE: GitHub (Public) access - working 
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gcs_bucket/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  gcs_bucket_extension = "bucket-private" 
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true 
}

# Google Cloud Storage: Public
module "la_gcs_public" {
  ## REMOTE: GitHub (Public) access - working 
  # source = "github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable"
  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gcs_bucket/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  gcs_bucket_extension = "bucket-public" 
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true 
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = module.la_gcs_public.gcs_bucket_name
  role   = "roles/storage.objectViewer"
  member = "allUsers" # Makes the bucket readable by everyone
}
