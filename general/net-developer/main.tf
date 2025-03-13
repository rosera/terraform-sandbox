# ------------------ Cloud Code Developer: Integrated Development Environment   
# ------------------ Module Definition 
#

# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Virtual Private Cloud
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork

module "la_vpc" {
  ## NOTE: When changing the source parameter, `terraform init` is required

  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  # source = "./basics/vpc_network/stable"

  ## REMOTE: GitHub (Public) access - working
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_network/stable"
  ## source = "gcs::https://storage.googleapis.com/terraform-lab-foundation/basics/vpc_network/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  vpc_network             = "dev-network"
  vpc_network_description = "Developer network"
  vpc_subnet              = "dev-subnetwork"
  vpc_region              = "us-central1"
  vpc_subnet_cidr         = "10.128.0.0/16"
}


# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
# https://github.com/terraform-google-modules/terraform-google-network/tree/master/modules/firewall-rules

module "la_fw" {
  ## NOTE: When changing the source parameter, `terraform init` is required

  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/vpc_firewall/stable"
  ## source = "gcs::https://storage.googleapis.com/terraform-lab-foundation/basics/vpc_firewall/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## Ex: Default Network
  # fwr_network      = "default" 
  ## Ex: Custom Network - Network Output variable
  fwr_network      = module.la_vpc.vpc_network_name

  # Firewall Policy - Repeatable list of objects
  fwr_rules = [
  {
    fwr_name                    = "serverless-to-vpc-connector"
    fwr_description             = "serverless-to-vpc-connector"
    fwr_source_ranges           = [ "107.178.230.64/26", "35.199.224.0/19" ]
    fwr_destination_ranges      = null
    fwr_source_tags             = null
    fwr_source_service_accounts = null
    fwr_target_tags             = ["vpc-connector"]
    fwr_target_service_accounts = null
    fwr_priority                = "1000"
    fwr_direction               = "INGRESS"

    # Allow List
    allow = [{
      protocol     = "icmp"
      ports        = null 
    },
    {
      protocol     = "tcp"
      ports        = [ "667" ]
    },
    {
      protocol     = "udp"
      ports        = [ "665-666" ]
    }]

    # Deny List
    deny = []

    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }

  },
  {
    fwr_name                    = "vpc-connector-egress"
    fwr_description             = "vpc-connector-egress"
    fwr_source_ranges           = null 
    fwr_destination_ranges      = null
    fwr_source_tags             = [ "vpc-connector" ] 
    fwr_source_service_accounts = null
    fwr_target_tags             = null 
    fwr_target_service_accounts = null
    fwr_priority                = "1000"
    fwr_direction               = "INGRESS"

    # Allow List
    allow = [{
      protocol     = "tcp"
      ports        = null 
    },
    {
      protocol     = "udp"
      ports        = null 
    },
    {
      protocol     = "icmp"
      ports        = null 
    }]

    # Deny List
    deny = []

    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
  ]

  ## Firewall depends on existence of Network
  depends_on = [ module.la_vpc.vpc_network_name ]
}

# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vpc_access_connector

# Enable the vpc access service
resource "google_project_service" "vpcaccess-api" {
  project = var.gcp_project_id
  service = "vpcaccess.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  # disable_dependent_services = true
}

resource "google_vpc_access_connector" "connector" {
  provider      = google-beta
  project = var.gcp_project_id
  name          = "ideconn"
  region        = var.gcp_region
  network       = module.la_vpc.vpc_network_name 
  ip_cidr_range = "10.8.0.0/28"
  min_throughput= 200
  max_throughput= 300

  # Note: valid options: f1-micro, e2-micro, e2-standard-4
  machine_type = "e2-micro"

  depends_on = [ google_project_service.vpcaccess-api ]
}


# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
#
# Enable the Cloud Run service
resource "google_project_service" "run" {
  project = var.gcp_project_id
  service = "run.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  # disable_dependent_services = true
}

resource "google_cloud_run_service" "ide" {
  project = var.gcp_project_id
  name     = "learning-journey"
  # location = var.gcrRegion
  location = var.gcp_region

  template {
    spec {
      containers {
        image = "gcr.io/qwiklabs-resources/ide-proxy:latest"
        #image = var.gcrContainerImage 
      }
      container_concurrency = 2
    }

    # Add support for vpc connector
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"        = "3"
        "autoscaling.knative.dev/minScale"        = "1"
        "run.googleapis.com/vpc-access-egress"    = "all"
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.name
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Dependency - Cloud Run API enabled
  depends_on = [google_project_service.run, google_vpc_access_connector.connector ] 
}


data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.ide.location
  project  = google_cloud_run_service.ide.project
  service  = google_cloud_run_service.ide.name

  policy_data = data.google_iam_policy.noauth.policy_data
}


# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_instance
data "google_compute_image" "image_family" {
  family  = "cloud-code-codeserver" 
  project = "qwiklabs-resources"
}

# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
#

resource "google_compute_instance" "gce_virtual_machine" {

  name         = "gce-instance"
  machine_type = "n2-standard-2"
  zone         = "us-central1-f"
  project      = var.gcp_project_id

  tags           = ["lab-vm"]
  can_ip_forward = "false"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image_family.self_link
    }
  }

  network_interface {
    network = "dev-network"
    subnetwork = "dev-subnetwork"
    subnetwork_project = var.gcp_project_id

    access_config {
      // Ephemeral IP
    }
  }

  # Add Key/Value pair e.g. SSH keys here
  metadata = var.gce_metadata == null ? null : var.gce_metadata


  # Override to perform startup script
  metadata_startup_script = var.gce_startup_script == null ? null : var.gce_startup_script 

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # email  = google_service_account.default.email
    email = var.gce_service_account == null ? null : var.gce_service_account
    scopes = var.gce_scopes
  }
}

## # Module: Google Kubernetes Engine
## module "la_gke_standard" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/gke_cluster/stable"
##   source = "gcs::https://storage.googleapis.com/terraform-lab-foundation/basics/gke_cluster/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   # Customise the GKE instance
##   gke_name             = "lab_cluster" 
## }