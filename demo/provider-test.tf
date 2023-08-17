terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.84.0" # update to latest version!
    },
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.61.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone # not required but recommended
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone # not required but recommended
}
