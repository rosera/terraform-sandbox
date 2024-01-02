// local variable for remote-exec startup script
locals {
  startup_script_path = "${path.module}/startup.sh"
}

// render startup script dynamic variables via local-exec provisioner
resource "null_resource" "render_startup_script" {
  provisioner "local-exec" {
    command = "echo '${templatefile("${path.module}/startup.tpl", { zone = var.gcp_zone, region = var.gcp_region })}' > ${local.startup_script_path}"
  }

  triggers = {
    startup_script_contents = templatefile("${path.module}/startup.tpl", { zone = var.gcp_zone, region = var.gcp_region })
  }
}

// VM to run startup script 
resource "google_compute_instance" "lab_setup_vm" {
  name                      = "startup-vm"
  machine_type              = "e2-micro"
  zone                      = var.gcp_zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config { // Ephemeral IP
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

// remote exec provisioner for startup script
resource "null_resource" "remote-exec-resource" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.username
      private_key = var.ssh_pvt_key
      host        = google_compute_instance.lab_setup_vm.network_interface[0].access_config[0].nat_ip
    }
    script = local.startup_script_path
  }

  depends_on = [
    google_compute_instance.lab_setup_vm,
    null_resource.render_startup_script,
    google_project_service.cloudbuild,
    google_project_service.container,
    google_project_service.composer
  ]
}

resource "google_project_service" "container" {
  project = var.gcp_project_id
  service = "container.googleapis.com"
}

resource "google_project_service" "cloudbuild" {
  project = var.gcp_project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "composer" {
  project = var.gcp_project_id
  service = "composer.googleapis.com"
}
