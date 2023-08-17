variable "gcp_project_id" {
  type = string
  description = "Project ID"
}

variable "gcp_region" {
  type = string
  description = "assigned region"
}

variable "gcp_zone" {
  type = string
  description = "assigned zone"
}

variable "service_account_key_file" {
  type = string
  description = "key file location"
}