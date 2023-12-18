# Data: Project Information 
data "google_project" "project" {
  project_id = var.gcp_project_id
}

##----------------------------------------------------------------------------
## Create Private IP 

data "google_compute_network" "gcp-network" {
  project = var.gcp_project_id 
  name = "default"
}

## Add Googleapis
resource "google_project_service" "tlf" {
  ## https://developer.hashicorp.com/terraform/language/functions/toset
  ## Removes duplicates
  for_each = toset(var.gcp_apis_list)

  project = var.gcp_project_id 
  service = each.key

  disable_dependent_services = false
}

# Create an IP address
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "psa-range"
  project       = var.gcp_project_id 
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = data.google_compute_network.gcp-network.id
}

# Create a private connection
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection
resource "google_service_networking_connection" "default" {
  network                 = data.google_compute_network.gcp-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

##----------------------------------------------------------------------------
## Create AlloyDB
## https://github.com/GoogleCloudPlatform/terraform-google-alloy-db/blob/main/variables.tf
## Create AlloyDB Cluster

resource "google_alloydb_cluster" "default" {
  cluster_id = "alloydb-aip-01"
  location   = var.gcp_region 
  project    = var.gcp_project_id 

##   network    = data.google_compute_network.gcp-network.id
  network_config {
    network    = data.google_compute_network.gcp-network.id
  }

  initial_user {
    user     = var.alloydb_user 
    password = var.alloydb_password 
  }

  depends_on = [ data.google_compute_network.gcp-network, google_project_service.tlf  ]
}


## Create Ally Primary Instance
resource "google_alloydb_instance" "default" {
  cluster           = google_alloydb_cluster.default.name
  instance_id       = "alloydb-instance"
  instance_type     = "PRIMARY"
  display_name      = "alloydb-aip-01-pr"

  gce_zone          = var.gcp_zone
  availability_type = "ZONAL"

  machine_config {
    cpu_count = 2
  }

  # Add a dependency on the Project network
  depends_on = [ google_service_networking_connection.default ]
}

##----------------------------------------------------------------------------
## Create GCE Instance 
resource "google_compute_instance" "gce_virtual_machine" {

		name         = var.gce_name
		machine_type = var.gce_machine_type
		zone         = var.gcp_zone
		project      = var.gcp_project_id

		tags           = var.gce_tags
		can_ip_forward = var.gce_can_ip_forward

		boot_disk {
			initialize_params {
				image = var.gce_machine_image
			}
		}

		network_interface {
			network = var.gce_machine_network == "default" ? var.gce_machine_network : null
			subnetwork = var.gce_machine_network == "default" ? null : var.gce_machine_network

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

##----------------------------------------------------------------------------
## Bind role/permission to AlloyDB service account 

# Module: Bind role/permissions
locals {
  # Service account for AlloyDB
  service_account = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-alloydb.iam.gserviceaccount.com"
}

resource "time_sleep" "action_wait_duration" {
  create_duration = var.gcp_wait_duration 
  depends_on  = [ google_project_service.tlf ] 
}

resource "google_project_iam_member" "tlf" {
  for_each = {
    for idx, role in var.gcp_role_list: idx => {
      member = local.service_account
      role   = role 
    }
  }

  project = var.gcp_project_id 
  member  = local.service_account 
  role    = each.value.role

  depends_on  = [ time_sleep.action_wait_duration, google_alloydb_instance.default ] 
}
