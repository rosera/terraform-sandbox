## module "delete_default_fw_rules" {
##   source = "terraform-google-modules/gcloud/google"
##   version = "~> 3.0.1"
##   platform = "linux"
##   create_cmd_entrypoint = "chmod +x ${path.module}/scripts/script.sh;${path.module}/scripts/script.sh"
##   create_cmd_body = "${var.gcp_project_id}"
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
  service_account_key_file = var.service_account_key_file
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
  service_account_key_file = var.service_account_key_file

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
  name                    = "customer-net"
  project                 = var.gcp_project_id
  description             = "Customer network"
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
  name          = "private-subnet"
  project       = var.gcp_project_id
  ip_cidr_range = "198.168.10.0/24"
  region        = var.gcp_region
  stack_type    = "IPV4_ONLY"
  network       = google_compute_network.lab_network.id
}

resource "google_compute_subnetwork" "endpoint_subnet" {
  name          = "psc-subnet"
  project       = var.gcp_project_id
  ip_cidr_range = "192.168.30.0/24"
  region        = var.gcp_region
  stack_type    = "IPV4_ONLY"
  network       = google_compute_network.lab_network.id
}
#-----------------------------------------------------------------------------
# Custom Firewall
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
#-----------------------------------------------------------------------------
resource "google_compute_firewall" "allow-all-network" {
  name          = "customer-network-allow-custom"
  project       = var.gcp_project_id
  description   = "Allows connection from any source to any instance on the network using custom protocols."
  network       = google_compute_network.lab_network.name
  source_ranges = ["192.168.0.0/18"]
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
