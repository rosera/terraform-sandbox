## COMPUTE ENGINE 
## ----------------------------------------------------------------------------
resource "google_compute_instance" "startup-vm" {
  name                    = "startup-vm"
  description             = "Runs a script to remove viewer role from customer users"
  machine_type            = "n1-standard-4"
  zone                    = var.gcp_zone

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
  provisioner "file" {
        source = "scripts/tasks_checker.sh"
        destination = "~/tasks_checker.sh"
        connection {
            type = "ssh"
            user = "${var.gcp_username}"
            private_key = "${var.ssh_pvt_key}"
            host     = self.network_interface.0.access_config.0.nat_ip
        }
    }

    provisioner "remote-exec" {
        inline = [
          "sudo cp tasks_checker.sh ~/../../",
          "sudo chmod +x ~/../../tasks_checker.sh",
          "sudo rm ~/tasks_checker.sh"
        ]
        connection {
            type        = "ssh"
            user        = "${var.gcp_username}"
            private_key = "${var.ssh_pvt_key}"
            host        = self.network_interface.0.access_config.0.nat_ip
        }

    }

  service_account {
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = file("${path.module}/scripts/installer.sh")
  depends_on              = [google_project_iam_member.compute-owner-bind, google_project_service.bq-connection-api]
}

resource "google_compute_instance" "linuxhost" {
  name         = "linuxhost"
  description  = "Runs a script to remove viewer role from customer users"
  machine_type = "n1-standard-4"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = "projects/qwiklabs-resources/global/images/actifio-linuxhost1-boot-disk"
    }
  }

  attached_disk {
    source = "projects/${var.gcp_project_id}/global/disks/linuxhost1-disk2"
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  provisioner "remote-exec" {
        inline = [
          "sudo cp /tmp/connector-Linux-11.0.1.8756.rpm  ~/",
          "sudo chmod +x ~/connector-Linux-11.0.1.8756.rpm"
        ]
        connection {
            type        = "ssh"
            user        = "${var.gcp_username}"
            private_key = "${var.ssh_pvt_key}"
            host        = self.network_interface.0.access_config.0.nat_ip
        }
  }
  service_account {
    scopes = ["cloud-platform"]
  }
  depends_on   = [google_project_iam_member.compute-owner-bind, google_project_service.bq-connection-api, google_compute_disk.linuxhost1-disk2]
}

## COMPUTE ENGINE DISK 
## ----------------------------------------------------------------------------
resource "google_compute_disk" "linuxhost1-disk2" {
  name  = "linuxhost1-disk2"
  type  = "pd-ssd"
  zone  = var.gcp_zone
  image = "projects/qwiklabs-resources/global/images/actifio-linuxhost1-disk2"
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}
