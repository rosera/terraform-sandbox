variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to create the VM in."
}
 
variable "gcp_region" {
  type        = string
  description = "The GCP project ID to create the VM in."
}
 
variable "gcp_zone" {
  type        = string
  description = "The GCP project ID to create the VM in."
}

# variables defination qwiklabs.yaml
variable "secondary_region" {
  type = string
  description = "Secondary default region assigned to lab instance."
}

variable "third_region" {
  type = string
  description = "third default region assigned to lab instance."
}

variable "secondary_zone" {
  type = string
  description = "Secondary default region assigned to lab instance."
}

variable "third_zone" {
  type = string
  description = "third default region assigned to lab instance."
}
