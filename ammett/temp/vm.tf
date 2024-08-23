#-----------------------------------------------------------------------------
# Compute Compute Instance 
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
#-----------------------------------------------------------------------------
resource "google_compute_instance" "gce_virtual_machine" {

  name         = "sql-test-vm"
  machine_type = "e2-standard-2"
  zone         = var.gcp_zone
  project      = var.gcp_project_id

  # tags           = var.gce_tags
  # can_ip_forward = var.gce_can_ip_forward

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    # network  = google_compute_network.lab_network.id
    subnetwork = "test-vm-net"
    subnetwork_project = var.gcp_project_id

    #    access_config {
    #      // Ephemeral IP
    #    }
  }

  # Add Key/Value pair e.g. SSH keys here
  # metadata = var.gce_metadata == null ? null : var.gce_metadata

  # Override to perform startup script
  metadata_startup_script  = "${file("./scripts/lab-init.sh")}"

  #  service_account {
  #    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  #    # email  = google_service_account.default.email
  #    email = var.gce_service_account == null ? null : var.gce_service_account
  #    scopes = var.gce_scopes
  #  }

  # Add dependency on subnet creation
  depends_on = [google_compute_subnetwork.lab_subnet]
}
