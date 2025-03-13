resource "google_compute_network" "tfer--app-network" {
  auto_create_subnetworks         = "false"
  delete_default_routes_on_create = "false"
  enable_ula_internal_ipv6        = "false"
  mtu                             = "1460"
  name                            = "app-network"
  project                         = "qwiklabs-gcp-03-237dc53bb350"
  routing_mode                    = "REGIONAL"
}

resource "google_compute_network" "tfer--default" {
  auto_create_subnetworks         = "true"
  delete_default_routes_on_create = "false"
  description                     = "Default network for the project"
  enable_ula_internal_ipv6        = "false"
  mtu                             = "0"
  name                            = "default"
  project                         = "qwiklabs-gcp-03-237dc53bb350"
  routing_mode                    = "REGIONAL"
}
