resource "google_compute_network" "my-network" {
  name = "app-network"
  auto_create_subnetworks = false
  project = var.gcp_project_id
  mtu = 1460
  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "my-subnetwork-1" {
  name   = "app-network-vm-subnet"
  project = var.gcp_project_id
  ip_cidr_range = "10.0.77.0/24"  
  region = var.gcp_region
  stack_type = "IPV4_ONLY" 
  network = google_compute_network.my-network.id
  depends_on = [
    google_compute_network.my-network
  ]
}

resource "google_compute_subnetwork" "my-subnetwork-2" {
  name   = "lb-proxy-only-subnet"
  project = var.gcp_project_id
  ip_cidr_range = "10.0.88.0/24"  
  region = var.gcp_region
  network = google_compute_network.my-network.id
  purpose = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  depends_on = [
    google_compute_network.my-network
  ]
}

resource "google_compute_subnetwork" "my-subnetwork-3" {
  name   = "ilb-ip-subnet"
  project = var.gcp_project_id
  ip_cidr_range = "10.0.80.0/24"  
  region = var.gcp_region
  network = google_compute_network.my-network.id
  depends_on = [
    google_compute_network.my-network
  ]
}

resource "google_compute_firewall" "my-firewall-custom" {
  name    = "app-network-allow-custom"
  network = google_compute_network.my-network.id
  project = var.gcp_project_id
  source_ranges = ["10.0.64.0/18"]
  allow {
    protocol = "ALL"
  }
  depends_on = [
    google_compute_network.my-network
  ]
}

resource "google_compute_firewall" "my-firewall-ssh" {
  name    = "app-network-allow-ssh"
  network = google_compute_network.my-network.id
  project = var.gcp_project_id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [
    google_compute_network.my-network
  ]
}

resource "google_compute_firewall" "my-firewall-icmp" {
  name    = "app-network-allow-icmp"
  network = google_compute_network.my-network.id
  project = var.gcp_project_id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
  }

  depends_on = [
    google_compute_network.my-network
  ]
}


# resource "google_compute_firewall" "my-firewall-hc" {
#   name    = "app-network-allow-hc"
#   network = google_compute_network.my-network.id
#   project = var.gcp_project_id
#   source_ranges = ["35.191.0.0/16","130.211.0.0/22","209.85.152.0/22","209.85.204.0/22"]

#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }

#   allow {
#     protocol = "tcp"
#     ports    = ["8080"]
#   }

#   allow {
#     protocol = "tcp"
#     ports    = ["443"]
#   }
# }

resource "google_compute_router" "router1" {
  name    = "nat-gw-router"
  project = var.gcp_project_id
  region  = var.gcp_region
  network = google_compute_network.my-network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-gw-app"
  project                            = var.gcp_project_id
  router                             = google_compute_router.router1.name
  region                             = google_compute_router.router1.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_instance_template" "default" {
  name        = "app-servers"
  project     = var.gcp_project_id
  tags = ["app-server", "http-server", "https-server"]

  machine_type         = "e2-medium"

  scheduling {
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  disk {
    source_image      = "projects/debian-cloud/global/images/debian-11-bullseye-v20230912"
    auto_delete       = true
    boot              = true
    device_name       = "app-serverss"
    mode              = "READ_WRITE"
    disk_type         = "pd-balanced"
    disk_size_gb      = 10
  }

  network_interface {
    subnetwork = google_compute_subnetwork.my-subnetwork-1.self_link
  }

  metadata = {
    startup-script = <<-EOF
      #! /bin/bash
      apt update -y
      apt install nginx -y
      systemctl start nginx
      systemctl enable nginx
      systemctl status nginx | grep Active
      chown -R $USER:$USER /var/www
      cd /var/www/html/
      echo '<!DOCTYPE html>' > /var/www/html/index.html
      echo '<html>' >> /var/www/html/index.html
      echo '<head>' >> /var/www/html/index.html
      echo '<title>Welcome to the AI Webapp</title>' >> /var/www/html/index.html
      echo '<meta charset="UTF-8">' >> /var/www/html/index.html
      echo '</head>' >> /var/www/html/index.html
      echo '<body>' >> /var/www/html/index.html
      echo '<h1>AI Webapp Server</h1>' >> /var/www/html/index.html
      echo '<h3>Congratulations! You are successfully connected.</h3>' >> /var/www/html/index.html
      echo '</body>' >> /var/www/html/index.html
      echo '</html>' >> /var/www/html/index.html
    EOF
  }
}

resource "google_compute_health_check" "my-health-check" {
  name = "producer-app-hc"
  project = var.gcp_project_id
  check_interval_sec = 5
  timeout_sec        = 5
  unhealthy_threshold = 3
  healthy_threshold = 2

  http_health_check {
    port = 80
    proxy_header = "NONE"
  }

  log_config {
    enable = false
  }
}

resource "google_compute_region_instance_group_manager" "appserver" {
  name = "app-servers-ig"
  project = var.gcp_project_id
  region  = var.gcp_region

  base_instance_name = "app-servers"

  version {
    instance_template  = google_compute_instance_template.default.self_link_unique
  }

  target_size  = 1

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.my-health-check.id
    initial_delay_sec = 60
  }
}

resource "google_compute_region_autoscaler" "autoscaler" {

  name   = "my-autoscaler"
  project = var.gcp_project_id
  region  = var.gcp_region
  target = google_compute_region_instance_group_manager.appserver.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60
    mode = "ON"
    cpu_utilization {
      target = 0.6
    }
  }
}

module "lab_setup_vm" {
  source = "github.com/CloudVLab/terraform-lab-foundation/basics/gce_instance/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone
  gce_zone       = var.gcp_zone

  # Customise the GCE instance
  gce_name            = "lab-setup"
  gce_machine_type    = "e2-medium" 
  gce_tags            = ["lab-setup"] 
  gce_machine_image   = "debian-cloud/debian-11" 
  # gce_machine_network = "default" 
  gce_machine_network = google_compute_subnetwork.my-subnetwork-1.id  
  gce_scopes          = ["cloud-platform"]  
  depends_on = [ google_compute_subnetwork.my-subnetwork-1 ]
}

resource "null_resource" "remote-exec-resource" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "${var.username}"
      private_key = "${var.ssh_pvt_key}"
      host     = module.lab_setup_vm.gce_external_ip
    }
    script = "scripts/lab-init.sh"
  }

  depends_on = [module.lab_setup_vm]
}