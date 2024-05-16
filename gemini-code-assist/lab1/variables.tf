variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID to apply this config to."
}
variable "gcp_region" {
  type        = string
  description = "The GCP region to apply this config to."
}
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to apply this config to."
}
variable "gcp_user_id" {
  type        = string
  description = "The Qwiklab GCP user."
}
variable "service_account_key_file" {
  type = string
  description = "key file location"
}
