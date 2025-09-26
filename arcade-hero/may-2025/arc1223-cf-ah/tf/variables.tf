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
  type        = string
  description = "key file location"
}

variable "service_name" {
  type = string
  description = "key file location"
  default     = "genai-hero"
}

variable "cb_ar_name" {
  type = string
  description = "Arcade Lab Repository"
  default     = "arcade"
}

variable "container_image" {
  type = string
  description = "key file location"
  default     = "arcade-hero"
}

variable "gcf_runtime_language" {
  type        = string
  description = "Runtime language + version for Cloud Function"
  default     = "nodejs22"
}
