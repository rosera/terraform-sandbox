#-----------------------------------------------------------------------------
# Google Compute Instance Template
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
#-----------------------------------------------------------------------------
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
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
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
    subnetwork         = google_compute_subnetwork.lab_subnet.name
    subnetwork_project = var.gcp_project_id
  }

  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      # package updates      
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
      echo '<title>Welcome to the Producer Webapp</title>' >> /var/www/html/index.html
      echo '<meta charset="UTF-8">' >> /var/www/html/index.html
      echo '</head>' >> /var/www/html/index.html
      echo '<body>' >> /var/www/html/index.html
      echo '<h1>Webapp Server</h1>' >> /var/www/html/index.html
      echo '<h3>Congratulations! You are successfully connected.</h3>' >> /var/www/html/index.html
      echo '</body>' >> /var/www/html/index.html
      echo '</html>' >> /var/www/html/index.html
    EOF

  }

  ####  service_account {
  ##    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  ##    email  = google_service_account.default.email
  ##    scopes = ["cloud-platform"]
  ##  }

  # Add dependency on subnet creation
  depends_on = [google_compute_subnetwork.lab_subnet]
}

#-----------------------------------------------------------------------------
# Google Compute Health Check 
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check
#-----------------------------------------------------------------------------
resource "google_compute_health_check" "http-health-check" {
  name    = "producer-app-hc"
  project = var.gcp_project_id

  timeout_sec         = 5
  check_interval_sec  = 5
  unhealthy_threshold = 3
  healthy_threshold   = 2

  http_health_check {
    port         = "80"
    proxy_header = "NONE"
  }

  log_config {
    enable = false
  }
}

#-----------------------------------------------------------------------------
# Compute Target Pool
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_pool
#-----------------------------------------------------------------------------
# resource "google_compute_target_pool" "foobar" {
#     name = "my-target-pool"
# }

#-----------------------------------------------------------------------------
# Compute Instance Group - Managed
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager
#-----------------------------------------------------------------------------
resource "google_compute_region_instance_group_manager" "app-servers" {
  name               = "appserver-igm"
  project            = var.gcp_project_id
  base_instance_name = "app-servers"
  region             = var.gcp_region 
  distribution_policy_zones = [ "${var.gcp_zone}" ]

  version {
    instance_template = google_compute_instance_template.app_servers.id
    name              = "devrel"
  }

  ##   all_instances_config {
  ##     metadata = {
  ##       metadata_key = "metadata_value"
  ##     }
  ##     labels = {
  ##       label_key = "label_value"
  ##     }
  ##   }

  # target_pools = [google_compute_target_pool.appserver.id]
  # target_size = 1

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
    max_surge_fixed                = 1 
    #    max_surge_percent              = 20
    max_unavailable_fixed          = 0 
    #    min_ready_sec                  = 50
    #    replacement_method             = "RECREATE"
  }
}

#-----------------------------------------------------------------------------
# Compute Instance Group - Managed Autoscaler
# Reference:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_autoscaler
#-----------------------------------------------------------------------------
resource "google_compute_region_autoscaler" "app-autoscaler" {
  name    = "app-region-autoscaler"
  project = var.gcp_project_id
  region  = var.gcp_region 
  target  = google_compute_region_instance_group_manager.app-servers.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }

  # Add dependency on subnet creation
  depends_on = [google_compute_region_instance_group_manager.app-servers]
}
