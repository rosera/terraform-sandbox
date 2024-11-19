#-----------------------------------------------------------------------------
# Module: Google Cloud Storage
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
  gcs_bucket_extension = "bucket" 
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true 
}

#-----------------------------------------------------------------------------
# Create a bucket object containing a dynamically generated question
# The question can be anything.
# Example: Generate a question based on the data defined in lab_list

resource "google_storage_bucket_object" "task_object" {
  name   = "tasks.json"
  bucket = module.la_gcs.gcs_bucket_name

  ## Encode a question in JSON format
  content = jsonencode({
    "tasks": [
      # for task in var.tasks : {
      for task in local.tasks : {
        tag       = task.tag
        question  = task.question
        option_a  = task.options[0]
        option_b  = task.options[1]
        option_c  = task.options[2]
        option_d  = task.options[3]
        answer    = task.answer
      }
    ],
    "author": "Rich Rose",
    "publish": "18th Jan 2024"
    "uri": "${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net"
    "endpoint": "/arcade-1"
  })
}

resource "google_storage_bucket_object" "persona_object" {
  name   = "persona.json"
  bucket = module.la_gcs.gcs_bucket_name

  ## Encode a question in JSON format
  content = jsonencode({
    "persona": [
      for persona in local.personas : {
        name        = persona.name
        topic       = persona.topic
        knowledge   = persona.knowledge
        role        = persona.role
        messageText = persona.messageText
        imageUrl    = persona.imageUrl
        time        = persona.time
        endpoint    = persona.endpoint
      }
    ],
  })
}
