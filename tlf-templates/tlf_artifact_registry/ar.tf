# Artifact Registry

## Ref: https://cloud.google.com/artifact-registry/docs/transition/auto-migrate-gcr-ar

# 1. Enable API: artifactregistry.googleapis.com
# 2. Add Role permissions: artifact registry administrator + storage admin
# 3. Run gcloud command
# NOTE: PROJECTS is a single project or comma separated list.
#  ```bash
#  gcloud artifacts docker upgrade migrate \
#      --projects=PROJECTS
#  ```    
# 4. Create Artifact Repo


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository
resource "google_artifact_registry_repository" "my-repo" {
  location      = var.gcp_region 
  project       = var.gcp_project_id
  repository_id = "my-repository"
  description   = "Lab container repository"
  format        = "DOCKER"

  depends_on      = [ time_sleep.wait_api_delay ]
}
