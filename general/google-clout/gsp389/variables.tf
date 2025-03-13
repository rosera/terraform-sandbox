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

variable "prod_cluster_name" {
  type        = string
  description = "Production GKE Cluster name."
  default     = "prodcluster"
}

variable "staging_cluster_name" {
  type        = string
  description = "Staging GKE Cluster name."
  default     = "stagingcluster"
}

variable "test_cluster_name" {
  type        = string
  description = "Test GKE Cluster name."
  default     = "testcluster"
}

# QWIKLAB.YAML definitions
# variable: qlUsername 
variable "qlUsername" {
  type = string
}