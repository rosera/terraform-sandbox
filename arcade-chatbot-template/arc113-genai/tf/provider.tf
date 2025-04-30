# provider.tf - https://b.corp.google.com/issues/398222418
terraform {
  required_providers {
    google = {
      # https://registry.terraform.io/providers/hashicorp/google/latest
      version = ">=5.22.0"
    }
  }
}
