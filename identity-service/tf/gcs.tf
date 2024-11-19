# Set the notebook file name with the semantic version suffix
locals {
  full_notebook_name = "${var.notebook_name}-${var.notebook_version}.ipynb" 
}

// Create a startup script for the Workbench instance
resource "local_file" "notebook_config" {
  content  = <<EOF
  #!/bin/bash -e
  echo "STARTUP-SCRIPT: START"
  # Copy the notebook and requirements.txt files from the storage bucket
  sudo -u jupyter gsutil cp gs://${module.lab_config_bucket.gcs_bucket_name}/${local.full_notebook_name} /home/jupyter/${local.full_notebook_name}
  sudo -u jupyter gsutil cp gs://${module.lab_config_bucket.gcs_bucket_name}/requirements.txt /home/jupyter/
  # Install required python packages
  pip install --upgrade --no-warn-conflicts --no-warn-script-location -r /home/jupyter/requirements.txt
  echo "STARTUP-SCRIPT: END"
  EOF
  filename = "notebook_config.sh"
}

// Create a Cloud Storage bucket for the notebook file and startup script
module "lab_config_bucket" {
  source            = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gcs_bucket/stable"
  gcp_project_id    = var.gcp_project_id
  gcp_region        = var.gcp_region
  gcp_zone          = var.gcp_zone 
  gcs_bucket_extension = "labconfig-bucket" 
  gcs_storage_class    = "STANDARD"
  gcs_append_project   = true 
}

// Add the local notebook file to the Cloud Storage bucket
resource "google_storage_bucket_object" "notebook_file" {
  name   = local.full_notebook_name
  source = "notebooks/${var.notebook_name}.ipynb"
  bucket = module.lab_config_bucket.gcs_bucket_name
}

# Add the requirements.txt file to the Cloud Storage bucket
resource "google_storage_bucket_object" "requirements_file" {
  name   = "requirements.txt"
  source = var.requirements_file_path
  bucket = module.lab_config_bucket.gcs_bucket_name
}

// Add the startup script to the Cloud Storage bucket
resource "google_storage_bucket_object" "notebook_config_script" {
  name   = "notebook_config.sh"
  source = "notebook_config.sh"
  bucket = module.lab_config_bucket.gcs_bucket_name
  depends_on = [
    local_file.notebook_config,
    google_storage_bucket_object.notebook_file
  ]
}