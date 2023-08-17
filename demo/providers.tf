terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.84.0" # update to latest version!
    }
  }
}
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone # not required but recommended
}