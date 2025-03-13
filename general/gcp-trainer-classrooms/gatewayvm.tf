resource "google_compute_instance" "gateway_vm" {
  name         = "gateway"
  machine_type = "e2-small"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
    }
  }

  service_account {
    email  = google_service_account.gateway.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mhc-subnet.name
    access_config {
    }
  }

  tags = ["allow-api-http"]
}

module "la_gce" {

  source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/gce_instance/stable/v1"

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance

  gce_name            = "lab-vm"
  gce_machine_type    = "e2-small"
  gce_tags            = ["http-server", "https-server"]
}