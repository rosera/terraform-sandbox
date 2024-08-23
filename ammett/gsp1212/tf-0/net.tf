#-----------------------------------------------------------------------------
# Project: Set the PROJECT_ID 
# Reference:
# https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest
#-----------------------------------------------------------------------------
## module "cloud_project" {
##   source = "terraform-google-modules/gcloud/google"
##   version = "~> 3.0.1"
##   platform = "linux"
##   create_cmd_entrypoint = "gcloud"
##   create_cmd_body = "config set project ${var.gcp_project_id}"
##   skip_download = false
##   upgrade = false
##   gcloud_sdk_version = "358.0.0"
##   service_account_key_file = var.service_account_key_file
## }

#-----------------------------------------------------------------------------
# Firewall: Delete default VPC FW rules 
# Reference:
# https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest
#-----------------------------------------------------------------------------
module "delete_default_fw_rules" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "gcloud"
  create_cmd_body = "compute firewall-rules delete default-allow-icmp default-allow-ssh default-allow-internal default-allow-rdp --project=${var.gcp_project_id} --account=${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com --quiet"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  # gcloud_sdk_version = "421.0.0"
  service_account_key_file = var.service_account_key_file

  # Await completion of Default VPC FW Rules deletion
  ## module_depends_on = [
  ##   module.cloud_project
  ## ]
}

#-----------------------------------------------------------------------------
# VPC: Delete default VPC
# Reference:
# https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest
#-----------------------------------------------------------------------------
module "delete_default_vpc" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "gcloud"
  create_cmd_body = "compute networks delete default --project=${var.gcp_project_id} --account=${var.gcp_project_id}@${var.gcp_project_id}.iam.gserviceaccount.com --quiet"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  # gcloud_sdk_version = "421.0.0"
  service_account_key_file = var.service_account_key_file

  ## # Await completion of Default VPC FW Rules deletion
  ## module_depends_on = [
  ##   module.delete_default_fw_rules.wait
  ## ]

  # Await completion of Default VPC FW Rules deletion
  module_depends_on = [
    module.delete_default_fw_rules.wait
  ]
}


#-----------------------------------------------------------------------------
# Custom Network
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
#-----------------------------------------------------------------------------
resource "google_compute_network" "lab_network" {
  name                    = "app-network"
  project                 = var.gcp_project_id
  description             = "Lab network"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "REGIONAL"
}

#-----------------------------------------------------------------------------
# Custom Subnet
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
#-----------------------------------------------------------------------------
resource "google_compute_subnetwork" "lab_subnet" {
  name          = "app-subnet"
  project       = var.gcp_project_id
  ip_cidr_range = "10.0.24.0/24"
  region        = "us-central1"
  stack_type    = "IPV4_ONLY"
  network       = google_compute_network.lab_network.id
}

#-----------------------------------------------------------------------------
# Custom Firewall
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
#-----------------------------------------------------------------------------
resource "google_compute_firewall" "allow-all-network" {
  name          = "app-network-allow-custom"
  project       = var.gcp_project_id
  description   = "Allows connection from any source to any instance on the network using custom protocols."
  network       = google_compute_network.lab_network.name
  source_ranges = ["10.0.24.0/24", "10.0.34.0/24", "10.0.88.0/24"]
  direction     = "INGRESS"
  priority      = 65534

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "all"
  }

  depends_on = [google_compute_network.lab_network]
}

resource "google_compute_firewall" "allow-icmp-network" {
  name          = "app-network-allow-icmp"
  project       = var.gcp_project_id
  description   = "Allows ICMP connection from any source to any instance on the network."
  network       = google_compute_network.lab_network.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = 65534

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "icmp"
  }

  # Apply the rule to target_tags
  #  target_tags = ["lab-vm"]

  depends_on = [google_compute_network.lab_network]
}

resource "google_compute_firewall" "allow-rdp-network" {
  name          = "app-network-allow-rdp"
  project       = var.gcp_project_id
  description   = "Allows RDP connection from any source to any instance on the network."
  network       = google_compute_network.lab_network.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = 65534

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "tcp"
    ports    = ["3389"]
  }

  # Apply the rule to target_tags
  #  target_tags = ["lab-vm"]

  depends_on = [google_compute_network.lab_network]
}

resource "google_compute_firewall" "allow-ssh-network" {
  name          = "app-network-allow-ssh"
  project       = var.gcp_project_id
  description   = "Allows SSH connection from any source to any instance on the network."
  network       = google_compute_network.lab_network.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = 65534

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "tcp"
    ports    = ["22"]
  }

  # Apply the rule to target_tags
  #  target_tags = ["lab-vm"]

  depends_on = [google_compute_network.lab_network]
}

resource "google_compute_firewall" "allow-hc-network" {
  name          = "app-network-allow-hc"
  project       = var.gcp_project_id
  description   = "Allows health-check connection from any source to any instance on the network."
  network       = google_compute_network.lab_network.name
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  direction     = "INGRESS"
  priority      = 65534

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  # Apply the rule to target_tags
  #  target_tags = ["lab-vm"]

  depends_on = [google_compute_network.lab_network]
}
