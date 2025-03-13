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

## --------------------------------------------------------------
## Unit Test variable definitions
## --------------------------------------------------------------

# Default value passed in
variable "unit_test1_name" {
  type        = string
  description = "Description of Resource e.g. BQ Dataset"
  default     = "BQ Dataset"
}

# Default value passed in
variable "unit_test1_task" {
  type        = string
  description = "Description of action to be tested  e.g. Resource created."
  default     = "Create Resource"
}

