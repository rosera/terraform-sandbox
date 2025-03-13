# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Google Cloud Storage 
#-----------------------------------------------------------------------------
variable "gcp_gcs_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud_storage.png"
}

variable "gcp_bucket_1_name" {
  type        = string
  description = "GCS Bucket name"
  default     = "bucket"
}

variable "gcp_bucket_2_name" {
  type        = string
  description = "GCS Bucket name"
  default     = "bucket-object"
}

variable "gcp_bucket_2_role" {
  type        = string
  description = "GCS permission role"
  default     = "allUsers"
}

variable "gcp_bucket_2_member" {
  type        = string
  description = "GCS permission member"
  default     = "roles/storage.objectViewer"
}


# Variables: Google Cloud Storage 
#-----------------------------------------------------------------------------
module "gcs_bucket_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Google Cloud Storage 
  # Google Cloud Storage: Create a Bucket
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "gcs-1"
  title         = "Create a private Cloud Storage bucket"
  image         = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud-storage.png"
  resource_name = "${var.gcp_project_id}-${var.gcp_bucket_1_name}"

  challenges = [
    { step = "Name the bucket as \"${var.gcp_project_id}-${var.gcp_bucket_1_name}\".", command = "${var.gcp_project_id}-${var.gcp_bucket_1_name}" },
    { step = "Set the bucket \"Location type\" as Region.", command = "" },
    { step = "Select \"${var.gcp_region}\" from the available list.", command = "" },
    # ... more challenges
  ]

  instructions = [
    { step = "Open the Cloud Storage console.", command = "" },
    { step = "Click the \"CREATE\" button.", command = "" },
    { step = "Name the bucket as \"${var.gcp_project_id}-${var.gcp_bucket_1_name}\".", command = "${var.gcp_project_id}-${var.gcp_bucket_1_name}" },
    { step = "Set the bucket \"Location type\" as Region. Select \"${var.gcp_region}\" from the available list.", command = "" },
    { step = "Click the \"CONTINUE\" button in the \"Location type\".", command = "" },
    { step = "Click the \"CREATE\" button at the bottom of the screen.", command = "" },
    { step = "The \"Public access will be prevented\" notification is presented. Click the \"CONFIRM\" button to proceed.", command = "" },
    { step = "A message will indicate that the storage bucket ${var.gcp_project_id}-${var.gcp_bucket_1_name} has been successfully created.", command = "" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]
}

module "gcs_bucket_public" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Google Cloud Storage 
  # Google Cloud Storage: Create a Bucket
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "gcs-2"
  title         = "Create a public Cloud Storage bucket"
  image         = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud-storage.png"
  resource_name = "${var.gcp_project_id}-${var.gcp_bucket_2_name}"

  challenges = [
    { step = "Name the bucket as \"${var.gcp_project_id}-${var.gcp_bucket_2_name}\".", command = "${var.gcp_project_id}-${var.gcp_bucket_2_name}" },
    { step = "Set the bucket \"Location type\" as Region.", command = "" },
    { step = "Select \"${var.gcp_region}\" from the available list.", command = "" },
    { step = "Ensure the bucket can be assigned public access.", command = "" },
    # ... more challenges
  ]

  instructions = [
    { step = "Open the Cloud Storage console.", command = "" },
    { step = "Click the \"CREATE\" button.", command = "" },
    { step = "Name the bucket as \"${var.gcp_project_id}-${var.gcp_bucket_2_name}\".", command = "${var.gcp_project_id}-${var.gcp_bucket_2_name}" },
    { step = "Set the bucket \"Location type\" as Region. Select \"${var.gcp_region}\" from the available list.", command = "" },
    { step = "Click the \"CONTINUE\" button in the \"Location type\".", command = "" },
    { step = "Click the \"CREATE\" button at the bottom of the screen.", command = "" },
    { step = "The \"Public access will be prevented\" notification is presented. Uncheck the \"Enforce public access prevention on this bucket\" option.", command = "" },
    { step = "Click the \"CONFIRM\" button to proceed.", command = "" },
    { step = "A message will indicate that the storage bucket ${var.gcp_project_id}-${var.gcp_bucket_2_name} has been successfully created.", command = "" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]
}

module "gcs_bucket_object" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Google Cloud Storage 
  # Google Cloud Storage: Create a Bucket
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "gcs-3"
  title         = "Add Cloud Storage bucket public permissions"
  image         = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud-storage.png"
  resource_name = "${var.gcp_project_id}-${var.gcp_bucket_2_name}"

  challenges = [
    { step = "Assign the public access to the bucket \"${var.gcp_project_id}-${var.gcp_bucket_2_name}\".", command = "" },
    # ... more challenges
  ]

  instructions = [
    { step = "Open the Cloud Storage console.", command = "" },
    { step = "Assign the public access to the bucket \"${var.gcp_project_id}-${var.gcp_bucket_2_name}\".", command = "" },
    { step = "Open the Cloud Storage permissions tab.", command = "" },
    { step = "Add storage.objectView permissions to the allUser member.", command = "gcloud storage buckets add-iam-policy-binding  gs://${var.gcp_project_id}-${var.gcp_bucket_2_name} --member=${var.gcp_bucket_2_member} --role=${var.gcp_bucket_2_role}" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]
}
