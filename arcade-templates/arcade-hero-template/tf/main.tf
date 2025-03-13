# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Data Creation
#-----------------------------------------------------------------------------

# Locals: Define the Lab Topic 
#-----------------------------------------------------------------------------
locals {
  ## Define a Lab topic
  lab_topic = "Cloud Run functions"
}


# Locals: Create Tasks list dynamically
# Description: Use interpolation to create custom values based on environment
#-----------------------------------------------------------------------------
locals {
  tasks = [
    # module.gcs_bucket_create.task,
    # module.bq_dataset_create.task,
    # module.vpc_network_create.task,
    # module.vpc_subnet_create.task,
    # module.pubsub_topic_create.task,
    # module.fw_inbound_create.task,
    # module.fw_outbound_create.task,
    # module.fw_sourcetag_create.task,
    # module.ar_container_create.task,
    module.cloud_functions_create.task,

    # ... Add more tasks
  ]
}

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

#-----------------------------------------------------------------------------
# Application Deployment
#-----------------------------------------------------------------------------

# Build Frontend Application 

# Data: google_project 
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project

data "google_project" "project" {
  project_id = var.gcp_project_id
}

# Module: Enable Google APIs
#-----------------------------------------------------------------------------
module "la_api_batch" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/dev"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_services = ["run.googleapis.com", "eventarc.googleapis.com" ]
}

# Module: Bind Service Account to Role 
#-----------------------------------------------------------------------------
locals {
  #  PROJECT_NUMBER@cloudbuild.gserviceaccount.com
  service_account = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# Module: Bind Service Account to Role 
#-----------------------------------------------------------------------------
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

# Module: GCloud Task Runner
#-----------------------------------------------------------------------------
module "cloudbuild_script" {
  source                   = "terraform-google-modules/gcloud/google"
  # version                  = "~> 3.0.1"
  platform                 = "linux"
  create_cmd_entrypoint    = "chmod +x ${path.module}/scripts/lab-init.sh;${path.module}/scripts/lab-init.sh"
  create_cmd_body          = "${var.gcp_project_id} ${var.gcp_region} ${var.gcp_zone}"
  skip_download            = false
  upgrade                  = false
  gcloud_sdk_version       = "358.0.0"
  service_account_key_file = var.service_account_key_file
}

# Module: Cloud Run 
#-----------------------------------------------------------------------------
module "la_cloud_run" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/cloud_run/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  gcrService = "arcade-hero"
  # TODO: Deploy local container image
  gcrImage  = "gcr.io/${var.gcp_project_id}/arcade/arcade-hero"
  gcrRegion = var.gcp_region
  gcrEnvs = [
    { gcr_env_name = "STORAGE_URI", gcr_env_value = "TBC" },
    { gcr_env_name = "STORAGE_ENDPOINT", gcr_env_value = "/arcade-1" }
  ]
}
