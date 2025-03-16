#-----------------------------------------------------------------------------
# Module: GCloud Task Runner
# Dependency: Google Cloud Storage Objects: persona.json + tasks.json
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

  # Wait for delay before proceeding 
  # depends_on = [ time_sleep.object_creation_delay ]
}


