# Internal
resource "google_compute_firewall" "internal_allow_http" {
  name    = "internal-allow-http"
  network = google_compute_network.internal_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# External
resource "google_compute_firewall" "external_allow_http" {
  name    = "external-allow-http"
  network = google_compute_network.external_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

# Partner
resource "google_compute_firewall" "partner_allow_http" {
  name    = "partner-allow-http"
  network = google_compute_network.partner_network.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  source_ranges = ["0.0.0.0/0"]
}
