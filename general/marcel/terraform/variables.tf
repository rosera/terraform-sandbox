variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
  sensitive   = true
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "user_email" {
  description = "Specifies the Confluent Cloud environment to use"
  type = string
  sensitive = false
}

variable "gcp_project_id" {
    type        = string
    description = "The GCP project ID to apply this config to."
}
variable "gcp_region" {
    type        = string
    description = "The GCP region to apply this config to."
}
variable "gcp_zone" {
    type        = string
    description = "The GCP zone to apply this config to."
}
variable "qlUsername" {
    type = string
}
