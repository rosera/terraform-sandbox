# Create GCE Instances

# Internal servers
resource "google_compute_instance" "internal_server_1" {
  project                   = var.gcp_project_id
  name                      = "internal-server-1"
  machine_type              = "e2-micro"
  zone                      = var.gcp_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork      = google_compute_subnetwork.internal_subnet.name
    access_config { 
    }
  }
  depends_on = [ google_compute_network.internal_network ]
}

resource "google_compute_instance" "internal_server_2" {
  project                   = var.gcp_project_id
  name                      = "internal-server-2"
  machine_type              = "e2-micro"
  zone                      = var.gcp_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork      = google_compute_subnetwork.internal_subnet.name
    access_config { 
    }
  }
  depends_on = [ google_compute_network.internal_network ]
}

# External GCE with apache2 httpd
resource "google_compute_instance" "external_server" {
  project                   = var.gcp_project_id
  name                      = "external-server"
  machine_type              = "e2-micro"
  zone                      = var.secondary_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork      = google_compute_subnetwork.external_subnet.name
    access_config { 
    }
  }
  metadata = {
    startup-script = <<EOF
      sudo apt-get update -y
      sudo apt-get install -y apache2
      sudo systemctl start apache2
    EOF
  }  
  depends_on = [ google_compute_network.external_network ]
}

# Partner instance
resource "google_compute_instance" "partner_instance" {
  project                   = var.gcp_project_id
  name                      = "partner-instance"
  machine_type              = "e2-micro"
  zone                      = var.third_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork      = google_compute_subnetwork.partner_subnet.name
    access_config { 
    }
  }
  depends_on = [ google_compute_network.partner_network ]
}