provider "google" {
  project = "qwiklabs-gcp-04-22edd551c1ab"
}

terraform {
	required_providers {
		google = {
	    version = "~> 4.50.0"
		}
  }
}
