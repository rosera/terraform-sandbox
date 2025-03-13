output "google_container_cluster_tfer--gke_self_link" {
  value = "${google_container_cluster.tfer--gke.self_link}"
}

output "google_container_node_pool_tfer--gke_default-pool_id" {
  value = "${google_container_node_pool.tfer--gke_default-pool.id}"
}
