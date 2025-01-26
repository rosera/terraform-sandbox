terraform {
  required_providers {
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest
      source = "hashicorp/google"
      version = "5.22.0"
    }
    google-beta = {
      # https://registry.terraform.io/providers/hashicorp/google-beta/latest
      source = "hashicorp/google-beta"
      version = "5.22.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

