variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to apply this config to."
}
variable "gcp_region" {
  type        = string
  description = "The GCP region to apply this config to."
}
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to apply this config to."
}

# Custom Variables for remote-exec resource - must be defined in qwiklabs.yaml
variable "username" {
  type        = string
  description = "lab username"
}

