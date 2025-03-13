# Arcade Wheel
# Description: Create dynamic content for labs
# Example: Storage L1 Questions 
# Declare the JSON input as a local variable

locals {
  input_json = <<-EOT
  {
    "tasks": [
      {
        "ref": "Task 1",
        "title": "Make a Cloud Storage public",
        "instructions": [
          {"step": "Step 1: Open Google Cloud Console"},
          {"step": "Step 2: Click on Cloud Storage menu"},
          {"step": "Step 3: Click the checkbox for the available bucket"},
          {"step": "Step 4: At the top of the screen click the permissions"},
          {"step": "Step 5: Click the Add Principal button"},
          {"step": "Step 6: Enter the principal allUsers"},
          {"step": "Step 7: Enter the role as Storage Legacy Object Reader"},
          {"step": "Step 8: Click Save"},
          {"step": "Step 9: Click ALLOW PUBLIC ACCESS"}
        ],
        "image": "TBC",
        "topic": "Storage"
      }
    ]
  }
  EOT
}
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


resource "google_storage_bucket_object" "task_object" {
  name = "gcsl1.json"
  bucket = module.la_gcs.gcs_bucket_name
  content = local.input_json
##  jsonencode({
##    "tasks": local.input_json,
##    "author": "Rich Rose",
##    "publish": "15th Aug 2023"
##  })
}
