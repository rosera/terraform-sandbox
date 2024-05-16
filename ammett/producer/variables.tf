variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
  default = "us-central1"
}

variable "gcp_zone" {
  type = string
  default = "us-central1-a"
}

variable "username" {
  type        = string
  description = "lab username"
}

variable "ssh_pvt_key" {
  type        = string
  description = "The public SSH key for user"
}

variable "username2" {
  type        = string
  default = ""
  description = "lab username"
}

variable "ssh_pvt_key2" {
  type        = string
  default = ""
  description = "The public SSH key for user"
}