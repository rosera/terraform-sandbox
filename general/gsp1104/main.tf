resource "google_compute_instance" "startup-vm" {
  name                    = "startup-vm"
  machine_type            = "e2-micro"
  zone                    = var.gcp_zone
  metadata_startup_script = file("${path.module}/startup.sh")
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}
