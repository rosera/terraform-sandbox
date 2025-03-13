# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

#-----------------------------------------------------------------------------
# Compute Firewall - Disable Default 
#-----------------------------------------------------------------------------
## resource "google_compute_firewall" "default-allow-icmp" {
##   name          = "default-allow-icmp"
##   description   = "Disable default Firewall rulebase."
##   #name          = "default-allow-internal"
##   #name          = "default-allow-rdp"
##   #name          = "default-allow-ssh"
##   project       = var.gcp_project_id
##   network       = "default" 
##   source_tags   = ["app-server"]
##   direction     = "INGRESS"
##   # Enable INGRESS
##   allow {
##     # tcp, udp, icmp, esp, ah, sctp, ipip, all
##     protocol = "icmp"
##     # ports    = [ "80", "443", "8080" ]
##   }
##   disabled      = true
## }


# Ref: https://registry.terraform.io/modules/terraform-google-modules/gcloud/google/latest
## module "gcloud_cmd" {
##   source  = "terraform-google-modules/gcloud/google"
## #  version = "~> 2.0"
## 
##   platform = "linux"
##   additional_components = ["alpha"]
## 
##   create_cmd_entrypoint  = "gcloud"
##   create_cmd_body        = "compute firewall-rules delete default-allow-icmp"
##   gcloud_sdk_version     = "358.0.0"
## }

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

module "delete_default_fw_rules" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "gcloud"
  create_cmd_body = "compute firewall-rules delete default-allow-icmp default-allow-ssh default-allow-internal default-allow-rdp --project=${var.gcp_project_id} --quiet"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file
}

module "delete_default_vpc" {
  source = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"
  platform = "linux"
  create_cmd_entrypoint = "gcloud"
  create_cmd_body = "compute networks delete default --project=${var.gcp_project_id} --quiet"
  skip_download = false
  upgrade = false
  gcloud_sdk_version = "358.0.0"
  service_account_key_file = var.service_account_key_file

  # Await completion of Default VPC FW Rules deletion
  module_depends_on = [
    module.delete_default_fw_rules.wait
  ]
}

#-----------------------------------------------------------------------------
# Custom Network
# Custom Subnet
#-----------------------------------------------------------------------------

# Custom Network
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "lab_network" {
  name                    = "app-network"
  project                 = var.gcp_project_id
  description             = "Lab network"
  auto_create_subnetworks = false
  mtu                     = 1460
  routing_mode            = "REGIONAL"
}

# Custom Subnet
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "lab_subnet" {
  name          = "app-subnet"
  project       = var.gcp_project_id
  ip_cidr_range = "10.0.24.0/24"
  region        = "us-central1"
  stack_type    = "IPV4_ONLY"
  network       = google_compute_network.lab_network.id
}


#-----------------------------------------------------------------------------
# Custom Firewall
#-----------------------------------------------------------------------------
# Custom Firewall
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "allow-all-network" {
  name          = "app-network-allow-custom"
  project       = var.gcp_project_id
  description   = "Allows connection from any source to any instance on the network using custom protocols."
  network       = google_compute_network.lab_network.name
  source_ranges = [ "10.0.24.0/24", "10.0.34.0/24", "10.0.88.0/24" ]
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
  source_ranges = [ "0.0.0.0/0" ]
  direction     = "INGRESS"
  priority      = 65534 

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "icmp"
#    ports    = ["22"]
  }

  # Apply the rule to target_tags
#  target_tags = ["lab-vm"]

  depends_on = [google_compute_network.lab_network]
}

resource "google_compute_firewall" "allow-rdp-network" {
  name          = "app-network-allow-rdp"
  project       = var.gcp_project_id
  description   = "Allows RDP connection from any source to any instance on the network."
  network       = google_compute_network.lab_network.name
  source_ranges = [ "0.0.0.0/0" ]
  direction     = "INGRESS"
  priority      = 65534 

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "tcp"
    ports    = ["3389"]
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
  source_ranges = [ "0.0.0.0/0" ]
  direction     = "INGRESS"
  priority      = 65534 

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "tcp"
    ports    = ["22"]
  }

  # Apply the rule to target_tags
  target_tags = ["app-server"]

  depends_on = [google_compute_network.lab_network]
}

resource "google_compute_firewall" "allow-hc-network" {
  name          = "app-network-allow-hc"
  project       = var.gcp_project_id
  description   = "Allows health-check connection from any source to any instance on the network."
  network       = google_compute_network.lab_network.name
  source_ranges = [ "35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"  ]
  direction     = "INGRESS"
  priority      = 65534 

  # Enable INGRESS
  allow {
    # tcp, udp, icmp, esp, ah, sctp, ipip, all
    protocol = "tcp"
    ports    = [ "80", "443", "8080" ]
  }

  # Apply the rule to target_tags
  target_tags = ["app-server"]

  depends_on = [google_compute_network.lab_network]
}

#-----------------------------------------------------------------------------
# Compute Router 
#-----------------------------------------------------------------------------
resource "google_compute_router" "compute_router" {
  name    = "nat-gw-router"
  project = var.gcp_project_id
  network = google_compute_network.lab_network.name
  region  = "us-central1"
}

#-----------------------------------------------------------------------------
# NAT Gateway
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
}

#-----------------------------------------------------------------------------
# Google Compute Instance Template
#-----------------------------------------------------------------------------
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
resource "google_compute_instance_template" "app_servers" {
  name        = "app-servers"
  project     = var.gcp_project_id
  region      = "us-central1"
  description = "This template is used to create app server instances."

  tags = ["app-server", "http-server", "https-server"]

  labels = {
    environment = "devrel"
  }

  instance_description = "App server"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
    // backup the disk every day
#    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

#  // Use an existing disk resource
#  disk {
#    // Instance Templates reference disks by name, not self link
#    source      = google_compute_disk.foobar.name
#    auto_delete = false
#    boot        = false
#  }

  network_interface {
    # network           = google_compute_network.lab_network.name
    subnetwork          = google_compute_subnetwork.lab_subnet.name
    subnetwork_project  = var.gcp_project_id

    // Allocate External IP 
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    startup-script= <<-EOF
        #!/bin/bash
        # package updates
        sudo apt upgrade
        sudo apt update
        sudo apt install -y nginx
        sudo sed -i 's/Welcome to nginx!/Welcome to Producer/g' /var/www/html/index.nginx-debian.html
        sudo systemctl start nginx
    EOF

  }

####  service_account {
##    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
##    email  = google_service_account.default.email
##    scopes = ["cloud-platform"]
##  }

}

#-----------------------------------------------------------------------------
# Compute Healthchecks
#-----------------------------------------------------------------------------
##  resource "google_compute_region_health_check" "http-region-health-check" {
##   name                = "producer-app-hc"
##   project             = var.gcp_project_id
##   region              = "us-central1"
## 
##   timeout_sec         = 5 
##   check_interval_sec  = 5 
##   unhealthy_threshold = 3 
##   healthy_threshold   = 2 
## 
##   http_health_check {
##     port              = "80"
##     proxy_header      = "NONE"
##   }
## 
##   log_config {
##     enable = false 
##   }
## }

resource "google_compute_health_check" "http-health-check" {
  name                = "producer-app-hc"
  project             = var.gcp_project_id

  timeout_sec         = 5 
  check_interval_sec  = 5 
  unhealthy_threshold = 3 
  healthy_threshold   = 2 

  http_health_check {
    port              = "80"
    proxy_header      = "NONE"
  }

  log_config {
    enable = false 
  }
}

#-----------------------------------------------------------------------------
# Compute Instance Group - Managed
#-----------------------------------------------------------------------------
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager
resource "google_compute_instance_group_manager" "app-servers" {
  name = "appserver-igm"
  project             = var.gcp_project_id

  base_instance_name = "app-servers"
  zone               = "us-central1-a"

  version {
    instance_template  = google_compute_instance_template.app_servers.id
  }

##   all_instances_config {
##     metadata = {
##       metadata_key = "metadata_value"
##     }
##     labels = {
##       label_key = "label_value"
##     }
##   }

##  target_pools = [google_compute_target_pool.appserver.id]
  target_size  = 1 

##  named_port {
##    name = "customhttp"
##    port = 8888
##  }

  auto_healing_policies {
##    health_check      = google_compute_health_check.autohealing.id
##    health_check      = google_compute_region_health_check.http-region-health-check.id
    health_check      = google_compute_health_check.http-health-check.id
    initial_delay_sec = 300
  }

  update_policy {
    type                           = "PROACTIVE"
    minimal_action                 = "REPLACE"
    # most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed                = 2
#    max_surge_percent              = 20
    #  max_unavailable_fixed          = 2
#    min_ready_sec                  = 50
#    replacement_method             = "RECREATE"
  }
}

