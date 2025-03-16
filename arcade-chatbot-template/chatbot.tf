## Chatbot V3
#-----------------------------------------------------------------------------

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

## resource "time_sleep" "object_creation_delay" {
## 
##   create_duration = "300s"
##   depends_on = [ google_storage_bucket_object.persona_object, google_storage_bucket_object.task_object ]
## }


