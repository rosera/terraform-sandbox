provider "google" {
  project = "qwiklabs-gcp-03-237dc53bb350"
}

terraform {
	required_providers {
		google = {
	    version = "~> 4.41.0"
		}
  }
}
