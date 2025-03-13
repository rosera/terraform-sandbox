resource "google_project_service" "workstations" {
  project = var.gcp_project_id
  service = "workstations.googleapis.com"
}

resource "google_project_service" "cloudaicompanion" {
  project = var.gcp_project_id
  service = "cloudaicompanion.googleapis.com"
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

  idle_timeout = "7200s"


  host {
    gce_instance {
      machine_type                = "e2-standard-8"
      boot_disk_size_gb           = 100
      disable_public_ip_addresses = false
      pool_size                   = 1
    }
  }
  
  container {
    image = "europe-docker.pkg.dev/galloro-host/custom-workstations/java-tools:latest"
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
  workstation_id         = "duetai-workstation"
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
  create_cmd_body        = "workstations start duetai-workstation --cluster=workstation-cluster --config=workstation-config --region=${var.gcp_region} --project=${var.gcp_project_id}"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "450.0.0" 
service_account_key_file = var.service_account_key_file
}