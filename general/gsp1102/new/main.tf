## Manifest:
## ----------------------------------------------------------------------------
# Data Object
# API
# IAM Service Account 
# IAM Role
# IAM Role Member 
# IAM Role Binding
# Compute Engine
# Compute Engine Disk


## ## DATA Object
## ## ----------------------------------------------------------------------------
## ## Data for Project ID and number
## data "google_project" "project" {
##   project_id = var.gcp_project_id
## }
## 
## ## API ENABLE 
## ## ----------------------------------------------------------------------------
## resource "google_project_service" "bq-connection-api" {
##   project = var.gcp_project_id
##   service = "servicenetworking.googleapis.com"
## }
## 
## 
## ## IAM SERVICE ACCOUNT 
## ## ----------------------------------------------------------------------------
## data "google_compute_default_service_account" "default" {
## }

## ## IAM ROLE
## ## ----------------------------------------------------------------------------
## ## Adding the IAM role to the lab created student account for token0s
## 
## resource "google_service_account" "service_account" {
##   account_id   = "compute-startup"
##   display_name = "SA for lab startup"
## }
## 
## resource "google_service_account_iam_member" "owner_sa_role_bind" {
##   service_account_id = data.google_compute_default_service_account.default.name
##   role               = "roles/owner"
##   member             = "serviceAccount:${google_service_account.service_account.email}"
## }
## 
## ## IAM ROLE MEMBER
## ## ----------------------------------------------------------------------------
## resource "google_project_iam_member" "compute-owner-bind" {
##   project = var.gcp_project_id
##   role    = "roles/owner"
##   member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
## }
## 
## // Adding the IAM role to the compute engine account for tokens
## resource "google_project_iam_member" "compute-owner-bind1" {
##   project = var.gcp_project_id
##   role    = "roles/iam.serviceAccountOpenIdTokenCreator"
##   member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
## }
## 
## resource "google_project_iam_member" "compute-owner-bind2" {
##   project = var.gcp_project_id
##   role    = "roles/iam.serviceAccountTokenCreator"
##   member  = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
## }
## 
## ## IAM ROLE BINDING
## ## ----------------------------------------------------------------------------
## resource "google_project_iam_binding" "binding" {
##   project = var.gcp_project_id
##   role    = "roles/iam.serviceAccountOpenIdTokenCreator"
##   members = ["user:${var.gcp_username}@qwiklabs.net"]
## }
## 
## resource "google_project_iam_binding" "binding1" {
##   project = var.gcp_project_id
##   role    = "roles/iam.serviceAccountTokenCreator"
##   members = ["user:${var.gcp_username}@qwiklabs.net"]
## }
## 


## ## COMPUTE ENGINE 
## ## ----------------------------------------------------------------------------
## resource "google_compute_instance" "startup-vm" {
##   description             = "Runs a script to remove viewer role from customer users"
##   name                    = "startup-vm"
##   machine_type            = "n1-standard-4"
##   zone                    = var.gcp_zone
##   depends_on              = [google_project_iam_member.compute-owner-bind, google_project_service.bq-connection-api]
##   metadata_startup_script = file("${path.module}/scripts/installer.sh")
## 
##   boot_disk {
##     initialize_params {
##       image = "debian-cloud/debian-11"
##     }
##   }
##   network_interface {
##     network = "default"
##     access_config {
##       // Ephemeral public IP
##     }
##   }
##   service_account {
##     scopes = ["cloud-platform"]
##   }
##   provisioner "file" {
##         source = "tasks_checker.sh"
##         destination = "~/tasks_checker.sh"
##         connection {
##             type = "ssh"
##             user = "${var.gcp_username}"
##             private_key = "${var.ssh_pvt_key}"
##             host     = self.network_interface.0.access_config.0.nat_ip
##         }
##     }
## 
##     provisioner "remote-exec" {
##         inline = [
##           "sudo cp tasks_checker.sh ~/../../",
##           "sudo chmod +x ~/../../tasks_checker.sh",
##           "sudo rm ~/tasks_checker.sh"
##         ]
##         connection {
##             type        = "ssh"
##             user        = "${var.gcp_username}"
##             private_key = "${var.ssh_pvt_key}"
##             host        = self.network_interface.0.access_config.0.nat_ip
##         }
## 
##     }
## 
## }
## 
## resource "google_compute_instance" "linuxhost" {
##   description  = "Runs a script to remove viewer role from customer users"
##   name         = "linuxhost"
##   machine_type = "n1-standard-4"
##   zone         = var.gcp_zone
##   depends_on   = [google_project_iam_member.compute-owner-bind, google_project_service.bq-connection-api, google_compute_disk.linuxhost1-disk2]
## 
##   boot_disk {
##     initialize_params {
##       image = "projects/qwiklabs-resources/global/images/actifio-linuxhost1-boot-disk"
##     }
##   }
## 
##   attached_disk {
##     source = "projects/${var.gcp_project_id}/global/disks/linuxhost1-disk2"
##   }
## 
##   network_interface {
##     network = "default"
##     access_config {
##       // Ephemeral public IP
##     }
##   }
##   service_account {
##     scopes = ["cloud-platform"]
##   }
## 
##   provisioner "remote-exec" {
##         inline = [
##           "sudo cp /tmp/connector-Linux-11.0.1.8756.rpm  ~/",
##           "sudo chmod +x ~/connector-Linux-11.0.1.8756.rpm"
##         ]
##         connection {
##             type        = "ssh"
##             user        = "${var.gcp_username}"
##             private_key = "${var.ssh_pvt_key}"
##             host        = self.network_interface.0.access_config.0.nat_ip
##         }
##   }
## 
## }
## 
## ## COMPUTE ENGINE DISK 
## ## ----------------------------------------------------------------------------
## resource "google_compute_disk" "linuxhost1-disk2" {
##   name  = "linuxhost1-disk2"
##   type  = "pd-ssd"
##   zone  = var.gcp_zone
##   image = "projects/qwiklabs-resources/global/images/actifio-linuxhost1-disk2"
##   labels = {
##     environment = "dev"
##   }
##   physical_block_size_bytes = 4096
## }


# resource "google_compute_instance_from_machine_image" "linuxhost" {
#   provider             = google-beta
#   name                 = "linuxhost"
#   zone                 = var.gcp_zone
#   source_machine_image = "projects/qwiklabs-resources/global/machineImages/dri-linux-host-image"
#
#   // Override fields from machine image
#   # can_ip_forward = false
#   # labels = {
#   #   my_key = "my_value"
#   # }
# }
