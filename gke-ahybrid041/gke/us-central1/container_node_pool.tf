resource "google_container_node_pool" "tfer--gke_default-pool" {
  cluster            = "${google_container_cluster.tfer--gke.name}"
  initial_node_count = "3"
  location           = "us-central1-a"

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  max_pods_per_node = "110"
  name              = "default-pool"

  network_config {
    create_pod_range     = "false"
    enable_private_nodes = "false"
    pod_ipv4_cidr_block  = "10.24.0.0/14"
    pod_range            = "gke-gke-pods-be6a9ca7"
  }

  node_config {
    disk_size_gb    = "100"
    disk_type       = "pd-balanced"
    image_type      = "COS_CONTAINERD"
    local_ssd_count = "0"
    logging_variant = "DEFAULT"
    machine_type    = "n1-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
    preemptible  = "false"

    resource_labels = {
      mesh_id = "proj-946522468759"
    }

    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = "true"
      enable_secure_boot          = "false"
    }

    spot = "false"

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  node_count     = "3"
  node_locations = ["us-central1-a"]
  project        = "qwiklabs-gcp-04-22edd551c1ab"

  upgrade_settings {
    max_surge       = "1"
    max_unavailable = "0"
    strategy        = "SURGE"
  }

  version = "1.24.8-gke.2000"
}
