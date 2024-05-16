# Qwiklabs Mandatory Values
variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "psc_sql_ip" {
  type = string
  default = "192.168.90.200"
}
