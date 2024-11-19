variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "aiplatform.googleapis.com",
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "notebooks.googleapis.com"
  ]
}

resource "google_project_service" "gcp_services" {
  for_each = toset(var.gcp_service_list)
  project  = var.gcp_project_id
  service  = each.key
}


# Override existing policy with least privilege SA new policy
data "google_project" "project" {
  project_id = var.gcp_project_id
}

resource "google_project_iam_policy" "project_policy" {
  project     = "${var.gcp_project_id}"
  policy_data = data.google_iam_policy.new_policy.policy_data
  depends_on = [google_project_service.gcp_services]
}

data "google_iam_policy" "new_policy" {
  binding {
    role = "roles/viewer"
    members = [
      "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
       "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
    ]
  }
  binding {
    role = "roles/owner"
    members = [
      "serviceAccount:admiral@qwiklabs-services-prod.iam.gserviceaccount.com"
    ]
  }
  
  audit_config {
    service = "aiplatform.googleapis.com"
    audit_log_configs {
      log_type = "DATA_READ"
    }

    audit_log_configs {
      log_type = "DATA_WRITE"
    }
  }
  binding {
    role = "roles/editor"
    members = [
     "user:${var.username}@qwiklabs.net"
    ]
  }
  binding {
    role = "roles/logging.admin"
    members = [
     "serviceAccount:${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com"
    ]
  }
}
