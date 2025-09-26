# Module: Google Cloud Storage
#-----------------------------------------------------------------------------
module "la_gcs" {
  ## NOTE: When changing the source parameter, `terraform init` is required

  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  #source = "./basics/gcs_bucket/stable"

  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/gcs_bucket/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  gcs_bucket_extension = "app"
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true
}

# Resource: google_storage_bucket_object 
# Description: Create a bucket JSON file containing a dynamically generated question
#-----------------------------------------------------------------------------

resource "google_storage_bucket_object" "task_object" {
  name   = "tasks.json"
  bucket = module.la_gcs.gcs_bucket_name

  ## Encode a question in JSON format
  content = jsonencode({
    "tasks" : [
      for task in local.tasks : {
        project_id    = var.gcp_project_id
        region        = var.gcp_region
        zone          = var.gcp_zone
        ref           = task.ref
        title         = task.title
        image         = task.image
        resource_name = task.resource_name
        challenges    = task.challenges
        instructions  = task.instructions
      }
    ],
    "author" : "Rich Rose",
    "publish" : "14th Dec 2023"
  })
}


