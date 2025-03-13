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

variable "container_image" {
  type = string
  description = "key file location"
  default     = "arcade-adventure"
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Google Cloud BiqQuery"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Professional Database Engineer preparation"
}

variable "lab_code" {
  type        = string
  description = "Lab code to be shown"
  default     = "bq4"
}
