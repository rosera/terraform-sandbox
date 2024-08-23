## --------------------------------------------------------------
## Mandatory variable definitions
## --------------------------------------------------------------

variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to create resources in."
}

# Default value passed in
variable "gcp_region" {
  type        = string
  description = "Region to create resources in."
}

# Default value passed in
variable "gcp_zone" {
  type        = string
  description = "Zone to create resources in."
}

# Lab username
variable "gcp_username" {
  type        = string
  description = "The lab username"
}

# Private key
variable "ssh_pvt_key" {
  type        = string
  description = "The public SSH key for user"
}
