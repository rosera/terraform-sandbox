# Qwiklabs Mandatory: PROJECT_ID
variable "gcp_project_id" {
  type = string
}

# Qwiklabs Mandatory: REGION
variable "gcp_region" {
  type = string
}

# Qwiklabs Mandatory: ZONE
variable "gcp_zone" {
  type = string
}

# Qwiklabs Optional: Service Account Key 
variable "service_account_key_file" {
  type        = string
  description = "key file location"
}
