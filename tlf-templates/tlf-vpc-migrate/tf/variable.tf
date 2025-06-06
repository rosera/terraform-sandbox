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

variable "service_account_key_file" {
  type        = string
  description = "key file location"
}

## --------------------------------------------------------------
## Unit Test variable definitions
## --------------------------------------------------------------

# Default value passed in
variable "unit_test1_name" {
  type        = string
  description = "Description of action to be tested  e.g. Resource created."
  default     = "VPC Creation"
}

# Default value passed in
variable "unit_test2_task" {
  type        = string
  description = "Description of action to be tested  e.g. Resource created."
  default     = "Subnet Creation"
}

# Default value passed in
variable "unit_test3_task" {
  type        = string
  description = "Description of action to be tested  e.g. Resource created."
  default     = "FW Ingress Rule Creation"
}


# Default value passed in
variable "unit_test4_task" {
  type        = string
  description = "Description of action to be tested  e.g. Resource created."
  default     = "GCE Instance Creation"
}
