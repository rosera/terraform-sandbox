resource "google_compute_instance_template" "tfer--app-servers" {
  can_ip_forward = "false"

  disk {
    auto_delete  = "true"
    boot         = "true"
    device_name  = "app-servers"
    disk_size_gb = "20"
    disk_type    = "pd-balanced"
    mode         = "READ_WRITE"
    source_image = "https://compute.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-stream-8-v20220822"
    type         = "PERSISTENT"
  }

  machine_type = "n1-standard-1"

  metadata = {
    startup-script = "#!/bin/bash\n# package updates\nsudo yum check-update\nsudo yum update \n\n# apache installation, enabling and status check\nsudo yum -y install httpd\nsudo systemctl start httpd\nsudo systemctl enable httpd\nsudo systemctl status httpd | grep Active\n\n\n# adding the needed permissions for creating and editing the index.html file\nsudo chown -R $USER:$USER /var/www\n# creating the html landing page\ncd /var/www/html/\necho '<!DOCTYPE html>' > index.html\necho '<html>' >> index.html\necho '<head>' >> index.html\necho '<title>Welcome to producer webapp</title>' >> index.html\necho '<meta charset=\"UTF-8\">' >> index.html\necho '</head>' >> index.html\necho '<body>' >> index.html\necho '<h1>Producer Server</h1>' >> index.html\necho '<h3>You are successful</h3>' >> index.html\necho '</body>' >> index.html\necho '</html>' >> index.html\n\n"
  }

  name = "app-servers"

  network_interface {
    network            = "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-03-237dc53bb350/global/networks/app-network"
    queue_count        = "0"
    subnetwork         = "https://www.googleapis.com/compute/v1/projects/qwiklabs-gcp-03-237dc53bb350/regions/us-central1/subnetworks/app-subnet"
    subnetwork_project = "qwiklabs-gcp-03-237dc53bb350"
  }

  project = "qwiklabs-gcp-03-237dc53bb350"
  region  = "us-central1"

  reservation_affinity {
    type = "ANY_RESERVATION"
  }

  scheduling {
    automatic_restart   = "true"
    min_node_cpus       = "0"
    on_host_maintenance = "MIGRATE"
    preemptible         = "false"
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "default"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/pubsub", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = "true"
    enable_secure_boot          = "false"
    enable_vtpm                 = "true"
  }

  tags = ["app-server", "http-server", "https-server"]
}
