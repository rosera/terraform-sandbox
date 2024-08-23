
module "project" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.4"
  project_id = var.gcp_project_id
  activate_apis = [
    "artifactregistry.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "workstations.googleapis.com",
    "cloudaicompanion.googleapis.com",
    "run.googleapis.com"
  ]
}

data "google_compute_default_service_account" "default" {
}

resource "google_sql_database_instance" "default" {
  project          = module.project.project_id
  name             = "demo-instance"
  database_version = "POSTGRES_15"
  region           = var.gcp_region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    disk_type = "PD_HDD"
    disk_size = 10
  }
}

resource "google_sql_database" "default" {
  project  = module.project.project_id
  name     = "demo-database"
  instance = google_sql_database_instance.default.name
}

resource "random_password" "pwd" {
  length  = 16
  special = false
}

resource "google_sql_user" "user" {
  project  = module.project.project_id
  name     = "voting-app"
  instance = google_sql_database_instance.default.name
  password = random_password.pwd.result
}

data "archive_file" "source_zip" {
  type        = "zip"
  source_dir  = "${path.root}/tabs-spaces-voting/"
  output_path = "${path.root}/tabs-spaces-voting.zip"
}

resource "google_storage_bucket" "source_bucket" {
  project                     = module.project.project_id
  name                        = "${var.gcp_project_id}-src"
  location                    = var.gcp_region
  uniform_bucket_level_access = true
  force_destroy               = true
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_object" "source_code_object" {  
  name   = "tabs-spaces-voting.zip"
  bucket = google_storage_bucket.source_bucket.name
  source = data.archive_file.source_zip.output_path
}

resource "google_secret_manager_secret" "sql_user_pass" {
  project   = module.project.project_id
  secret_id = "voting-app-password"
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "sql_user_pass" {
  secret = google_secret_manager_secret.sql_user_pass.id
  secret_data = random_password.pwd.result
}

resource "google_service_account" "cloud_run" {
  account_id   = "cloud-run"
  display_name = "Cloud Run Service Account"
  project      = module.project.project_id
}

resource "google_secret_manager_secret_iam_binding" "binding" {
  project = google_secret_manager_secret.sql_user_pass.project
  secret_id = google_secret_manager_secret.sql_user_pass.secret_id
  role = "roles/secretmanager.secretAccessor"
  members = [
    google_service_account.cloud_run.member,
  ]
}

resource "google_workstations_workstation_cluster" "default" {
  provider               = google-beta
  workstation_cluster_id = "workstation-cluster"
  project                = var.gcp_project_id
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = var.gcp_region
}

resource "google_workstations_workstation_config" "default" {
  provider               = google-beta
  workstation_config_id  = "workstation-config"
  project                = var.gcp_project_id
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.gcp_region

  idle_timeout = "28000s"


  host {
    gce_instance {
      machine_type                = "e2-standard-8"
      boot_disk_size_gb           = 100
      disable_public_ip_addresses = false
      pool_size                   = 1
    }
  }
  persistent_directories {
    mount_path = "/home"
    gce_pd {
      size_gb        = 200
      fs_type        = "ext4"
      disk_type      = "pd-standard"
      reclaim_policy = "DELETE"
    }
  }
}

resource "google_workstations_workstation" "default" {
  provider               = google-beta
  workstation_id         = "developer-workstation"
  workstation_config_id  = google_workstations_workstation_config.default.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.gcp_region

}

resource "google_workstations_workstation_iam_member" "member" {
  provider = google-beta
  project = var.gcp_project_id
  location = var.gcp_region
  workstation_cluster_id = google_workstations_workstation.default.workstation_cluster_id
  workstation_config_id = google_workstations_workstation.default.workstation_config_id
  workstation_id = google_workstations_workstation.default.workstation_id
  role = "roles/workstations.user"
  member = "user:${var.gcp_user_id}@qwiklabs.net"
}

resource "google_compute_network" "default" {
  provider                = google-beta
  name                    = "workstation-network"
  project                 = var.gcp_project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider      = google-beta
  name          = "workstation-subnet"
  ip_cidr_range = "10.0.0.0/22"
  region        = var.gcp_region
  project       = var.gcp_project_id
  network       = google_compute_network.default.name
}

module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.3"

  platform = "linux"

  create_cmd_entrypoint  = "gcloud"
  create_cmd_body        = "workstations start developer-workstation --cluster=workstation-cluster --config=workstation-config --region=${var.gcp_region} --project=${var.gcp_project_id}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "450.0.0" 
service_account_key_file = var.service_account_key_file
}