// Temporary machine to create spanner instance on startup
resource "google_compute_instance" "tempvm" {

  name         = "temp-server"
  machine_type = "n1-standard-1"
  zone         = var.gcp_zone


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    startup-script = <<SCRIPT
        #!/bin/bash
        gcloud services enable iam.googleapis.com
        gcloud services enable cloudresourcemanager.googleapis.com
        gcloud services enable iam.googleapis.com container.googleapis.com \
          cloudbuild.googleapis.com artifactregistry.googleapis.com \
          clouddeploy.googleapis.com containeranalysis.googleapis.com
        gcloud services enable cloudresourcemanager.googleapis.com
        gcloud services enable sourcerepo.googleapis.com 
        echo gcloud compute instance delete temp-server --zone=${var.gcp_zone}

      SCRIPT
  }

  service_account {
    scopes = ["cloud-platform"]
  }

}

resource "time_sleep" "wait" {
  create_duration = "10s"
  depends_on = [
    google_compute_instance.tempvm
  ]
}

resource "google_project_iam_binding" "cloud_deploy_user" {
  project = var.gcp_project_id
  role    = "roles/clouddeploy.jobRunner"
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}"
  ]
  depends_on = [
     time_sleep.wait
  ]
}
resource "google_project_iam_binding" "cloud_container_user" {
  project = var.gcp_project_id
  role    = "roles/container.developer"
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}"
  ]
  depends_on = [
     time_sleep.wait
  ]
}
resource "google_project_iam_binding" "cloud_source_admin" {
  project = var.gcp_project_id
  role    = "roles/source.admin"
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}"
  ]
  depends_on = [
     time_sleep.wait
  ]
}

// Temporary machine to create startup repo
resource "google_compute_instance" "labvm" {

  name         = "lab-server"
  machine_type = "n1-standard-1"
  zone         = var.gcp_zone


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    startup-script = <<SCRIPT
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install git kubectl -y
        
        export PROJECT_ID=$(gcloud config get-value core/project)
        export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID \
          --format="value(projectNumber)")
        export REGION=${var.gcp_region}
        export ZONE=${var.gcp_zone}
        
        mkdir work
        cd /work
        sudo gsutil cp gs://sureskills-lab-dev/gsp389/pop-kustomize.tar.gz .
        sudo tar -xvf pop-kustomize.tar.gz
        cd pop-kustomize

        sudo git config --global user.email "$(gcloud config get-value core/account)"
        sudo git config --global user.name "student"
        sudo git config --file=.git/config core.repositoryformatversion 1
        sudo git init
        sudo git config --global --add safe.directory /work/pop-kustomize
        sudo git add .
        sudo git commit -m "Initial commit"
        sudo git tag v1.0.0
        
        # PROJECT_NUMBER-compute@developer.gserviceaccount.com needs role Source Repository Administrator to create repos (roles/source.admin)
        # This is why the depend_on is used below

        gcloud source repos create pop-kustomize
        sudo git config credential.helper gcloud.sh
        sudo git remote add origin https://source.developers.google.com/p/$PROJECT_ID/r/pop-kustomize
        
        sudo git push origin master
        sudo git push --tags

      SCRIPT
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  depends_on = [
    # the Source Repo API must be enabled and the IAM role needs to be added to the SA first
      google_project_iam_binding.cloud_source_admin
  ]

}
 
 
// GKE 1 node Cluster Prod
resource "google_container_cluster" "prod" {
  name               = var.prod_cluster_name
  location           =  var.gcp_region
  node_locations     =  [var.gcp_zone]
  initial_node_count = 1
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  timeouts {
    create = "10m"
    update = "15m"
  }
}

// GKE 1 node Cluster Staging
resource "google_container_cluster" "staging" {
  name               = var.staging_cluster_name
  location           =  var.gcp_region
  node_locations     =  [var.gcp_zone]
  initial_node_count = 1
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  timeouts {
    create = "10m"
    update = "15m"
  }
}

// GKE 1 node Cluster Test
resource "google_container_cluster" "test" {
  name               = var.test_cluster_name
  location           =  var.gcp_region
  node_locations     =  [var.gcp_zone]
  initial_node_count = 1
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  timeouts {
    create = "10m"
    update = "15m"
  }
}