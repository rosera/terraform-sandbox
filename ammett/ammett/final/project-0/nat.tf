#-----------------------------------------------------------------------------
# Compute Router 
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
#-----------------------------------------------------------------------------
resource "google_compute_router" "compute_router" {
  name    = "nat-gw-router"
  project = var.gcp_project_id
  network = google_compute_network.lab_network.name
  region  = "us-central1"

  # Add dependency on subnet creation
  depends_on = [google_compute_subnetwork.lab_subnet]
}

#-----------------------------------------------------------------------------
# Compute Router Nat 
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
#-----------------------------------------------------------------------------
resource "google_compute_router_nat" "nat" {
  name                               = "nat-gw-app"
  project                            = var.gcp_project_id
  router                             = google_compute_router.compute_router.name
  region                             = google_compute_router.compute_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  # Add dependency on subnet creation
  depends_on = [google_compute_router.compute_router]
}
