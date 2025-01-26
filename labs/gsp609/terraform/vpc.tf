# 3 VPC Networks and their subnets in different regions
resource "google_compute_network" "internal_network" {
  name                    = "internal-network"
  auto_create_subnetworks = false
} 

resource "google_compute_network" "external_network" {
  name                    = "external-network"
  auto_create_subnetworks = false
} 

resource "google_compute_network" "partner_network" {
  name                    = "partner-network"
  auto_create_subnetworks = false
} 

resource "google_compute_subnetwork" "internal_subnet" {
  name          = "internal-subnet-${var.gcp_region}"
  network       = google_compute_network.internal_network.id
  region        = var.gcp_region
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_compute_subnetwork" "external_subnet" {
  name          = "external-subnet-${var.secondary_region}"
  network       = google_compute_network.external_network.id
  ip_cidr_range = "10.1.0.0/16"
  region        = var.secondary_region
}

resource "google_compute_subnetwork" "partner_subnet" {
  name          = "partner-subnet-${var.third_region}"
  network       = google_compute_network.partner_network.id
  ip_cidr_range = "10.2.0.0/16"
  region        = var.third_region
}