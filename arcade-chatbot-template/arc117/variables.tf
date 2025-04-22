#
# ------------------  Qwiklabs Values
#
variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "service_account_key_file" {
  type = string
  description = "key file location"
}

variable "gcp_ar_name" {
  type = string
  description = "Arcade Lab Repository"
  default     = "arcade"
}
variable "container_image" {
  type = string
  description = "key file location"
  default     = "arcade-frontend-chatv3"
}

variable "gcf_runtime_language" {
  type        = string
  description = "Runtime language + version for Cloud Function"
  default     = "nodejs22" 
}
