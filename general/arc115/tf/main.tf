#-----------------------------------------------------------------------------
# Arcade Wheel
# Description: Dynamic content for labs
# Ref: variables.tf lab_list

# Variables: Chatbot Tasks 
#-----------------------------------------------------------------------------

## Define a random number to index the list
## Constraint - uses zero to list length
resource random_integer "list_index" {
  min = 0
  max = length(var.lab_list) -1
}

## Define a random number to index the list items
## Constraint - item list, then uses zero to members list length
resource random_integer "item_index" {
  min = 0
  max = length(var.lab_list[local.list_index].members ) -1
}

# Random: List definitions created here 
locals {
  ## Define a Lab topic
  lab_topic   = var.lab_topic
  lab_persona = var.lab_persona
  lab_context = var.lab_context 

  ## Define random index
  list_index   = random_integer.list_index.result
  member_index = random_integer.item_index.result

  ## Define List Members
  lab_list   = [for item in var.lab_list : item.title]
  lab_item   = [for item in var.lab_list : item.members]
  lab_answer = [for item in var.lab_list : item.answer]

  ## Define Random selection 
  random_list = local.lab_list[local.list_index]
  random_item = local.lab_item[local.list_index][local.member_index]
}


# Task: Assessment questions defined here 
locals {
  tasks = [
    # Get the output object
    module.task_one.question,
    # module.task_two.question,
    # ... more tasks
  ]
}

# Task: Personas defined here 
locals {
  personas = [
    # Get the output object
    module.persona_one.persona,
    # ... more tasks
  ]
}

## Chatbot V3
#-----------------------------------------------------------------------------

# Module: Enable Google APIs
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = [ "run.googleapis.com" ] 
}

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
# Build Frontend Application 

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project
#
data "google_project" "project" {
  project_id = var.gcp_project_id
}

#-----------------------------------------------------------------------------
# Module: Bind Service Account to Role 
locals {
  #  PROJECT_NUMBER@cloudbuild.gserviceaccount.com
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

module "la_sa_role" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/iam_sa_role/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region 
  gcp_zone       = var.gcp_zone 

  ## Custom Properties
  # Pass the service account as principle member - non authorative binding
  iam_sa_name  = local.service_account
  iam_sa_roles = ["roles/storage.admin"]
}

#-----------------------------------------------------------------------------
# Module: GCloud Task Runner
module "cloudbuild_script" {
  source = "terraform-google-modules/gcloud/google"
  # version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
  create_cmd_body = "${var.gcp_project_id} ${var.gcp_region} ${var.gcp_zone} ${var.container_image}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file
}

#-----------------------------------------------------------------------------
# Module: Cloud Run 
module "la_cloud_run" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_run/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gcrService = "genai-chatbot"
  # TODO: Deploy local container image
  # gcrImage   = "gcr.io/qwiklabs-resources/arcade/arcade-frontend-chat"
  gcrImage   = "gcr.io/${var.gcp_project_id}/arcade/${var.container_image}"
  gcrRegion  = var.gcp_region 
  gcrEnvs    = [
    { gcr_env_name = "STORAGE_URI", gcr_env_value = "https://${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net" },
    { gcr_env_name = "STORAGE_ENDPOINT", gcr_env_value = "/arcade-1" }
  ]
}
