resource "google_compute_firewall" "tfer--app-network-allow-custom" {
  allow {
    protocol = "all"
  }

  description   = "Allows connection from any source to any instance on the network using custom protocols."
  direction     = "INGRESS"
  disabled      = "false"
  name          = "app-network-allow-custom"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--app-network_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["10.0.24.0/24", "10.0.34.0/24", "10.0.88.0/24"]
}

resource "google_compute_firewall" "tfer--app-network-allow-hc" {
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }

  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  allow {
    ports    = ["8080"]
    protocol = "tcp"
  }

  description   = "Allows health-checks"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "app-network-allow-hc"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--app-network_self_link}"
  priority      = "1000"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]
  target_tags   = ["app-server"]
}

resource "google_compute_firewall" "tfer--app-network-allow-icmp" {
  allow {
    protocol = "icmp"
  }

  description   = "Allows ICMP connections from any source to any instance on the network."
  direction     = "INGRESS"
  disabled      = "false"
  name          = "app-network-allow-icmp"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--app-network_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tfer--app-network-allow-rdp" {
  allow {
    ports    = ["3389"]
    protocol = "tcp"
  }

  description   = "Allows RDP connections from any source to any instance on the network using port 3389."
  direction     = "INGRESS"
  disabled      = "false"
  name          = "app-network-allow-rdp"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--app-network_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tfer--app-network-allow-ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  description   = "Allows TCP connections from any source to any instance on the network using port 22."
  direction     = "INGRESS"
  disabled      = "false"
  name          = "app-network-allow-ssh"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--app-network_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tfer--default-allow-icmp" {
  allow {
    protocol = "icmp"
  }

  description   = "Allow ICMP from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "default-allow-icmp"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--default_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tfer--default-allow-internal" {
  allow {
    ports    = ["0-65535"]
    protocol = "tcp"
  }

  allow {
    ports    = ["0-65535"]
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  description   = "Allow internal traffic on the default network"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "default-allow-internal"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--default_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["10.128.0.0/9"]
}

resource "google_compute_firewall" "tfer--default-allow-rdp" {
  allow {
    ports    = ["3389"]
    protocol = "tcp"
  }

  description   = "Allow RDP from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "default-allow-rdp"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--default_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tfer--default-allow-ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  description   = "Allow SSH from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "default-allow-ssh"
  network       = "${data.terraform_remote_state.networks.outputs.google_compute_network_tfer--default_self_link}"
  priority      = "65534"
  project       = "qwiklabs-gcp-03-237dc53bb350"
  source_ranges = ["0.0.0.0/0"]
}
