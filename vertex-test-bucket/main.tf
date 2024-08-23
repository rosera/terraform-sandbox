# 
data "google_storage_bucket_object" "source_object" {
  name   = "object-to-copy"
  bucket = "source-bucket-name"
}

resource "google_storage_bucket" "new_bucket" {
  name          = "${var.gcp_project_id}-bucket"
  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  location      = var.gcp_region 
  force_destroy = true  // Optional: Use with caution! Automatically deletes bucket and its contents on Terraform destroy.
}

resource "google_storage_bucket" "destination_bucket" {
  name          = "destination-bucket-name"
  location      = "EU" 
  force_destroy = true
}

resource "google_storage_bucket_object" "copied_object" {
  name   = data.google_storage_bucket_object.source_object.name
  bucket = google_storage_bucket.destination_bucket.name
  source = data.google_storage_bucket_object.source_object.output_name

  depends_on = [google_storage_bucket.destination_bucket]
}
