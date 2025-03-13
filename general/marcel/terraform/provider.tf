# Configure the Confluent Cloud Provider
terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.51.0"
    }
google = {
      source = "hashicorp/google"
    }
  } 
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

provider "google" {
  project      = var.gcp_project_id
  region       = local.gcp_region
  zone         = local.gcp_zone
}
