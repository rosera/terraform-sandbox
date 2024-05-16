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
  name          = "test-vm-net"
  project       = var.gcp_project_id
  ip_cidr_range = "198.168.50.0/24"
  region        = var.gcp_region
  stack_type    = "IPV4_ONLY"
  network       = google_compute_network.lab_network.id
}

resource "google_compute_subnetwork" "lab_subnet_2" {
  name          = "psc-endpoint-subnet"
  project       = var.gcp_project_id
  ip_cidr_range = "192.168.90.0/24"
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
  source_ranges = ["192.168.0.0/16"]
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
