resource "google_container_cluster" "tfer--gke" {
  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = "true"
    }

    network_policy_config {
      disabled = "true"
    }
  }

  cluster_autoscaling {
    enabled = "false"
  }

  cluster_ipv4_cidr = "10.24.0.0/14"

  database_encryption {
    state = "DECRYPTED"
  }

  default_max_pods_per_node   = "110"
  enable_binary_authorization = "false"
  enable_intranode_visibility = "false"
  enable_kubernetes_alpha     = "false"
  enable_l4_ilb_subsetting    = "false"
  enable_legacy_abac          = "false"
  enable_shielded_nodes       = "true"
  enable_tpu                  = "false"
  initial_node_count          = "0"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.24.0.0/14"
    services_ipv4_cidr_block = "10.28.0.0/20"
  }

  location = "us-central1-a"

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  logging_service = "logging.googleapis.com/kubernetes"

  master_auth {
    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  name               = "gke"
  network            = "projects/qwiklabs-gcp-04-22edd551c1ab/global/networks/default"

  network_policy {
    enabled  = "false"
    provider = "PROVIDER_UNSPECIFIED"
  }

  networking_mode = "VPC_NATIVE"

  node_pool_defaults {
    node_config_defaults {
      logging_variant = "DEFAULT"
    }
  }

  node_version = "1.24.8-gke.2000"

  notification_config {
    pubsub {
      enabled = "false"
    }
  }

  private_cluster_config {
    enable_private_endpoint = "false"
    enable_private_nodes    = "false"

    master_global_access_config {
      enabled = "false"
    }
  }

  project = "qwiklabs-gcp-04-22edd551c1ab"

  release_channel {
    channel = "REGULAR"
  }

  resource_labels = {
    mesh_id = "proj-946522468759"
  }

  service_external_ips_config {
    enabled = "false"
  }

  subnetwork = "projects/qwiklabs-gcp-04-22edd551c1ab/regions/us-central1/subnetworks/default"

  workload_identity_config {
    workload_pool = "qwiklabs-gcp-04-22edd551c1ab.svc.id.goog"
  }
}
