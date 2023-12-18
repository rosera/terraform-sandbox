# Qwiklabs Mandatory Values

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

//----------------------------------------------------------------------------

variable "gcp_apis_list" {
  type        = list 
  description = "List of Googleapis to enable" 
  default     = [ "alloydb.googleapis.com", "aiplatform.googleapis.com", "compute.googleapis.com", "servicenetworking.googleapis.com", "cloudresourcemanager.googleapis.com" ]
}

variable "gcp_role_list" {
  type        = list 
  description = "List of role permission to bind" 
  default     = [ "roles/aiplatform.user" ]
}

variable "gcp_wait_duration" {
  type        = string 
  description = "Duration to wait before action" 
  default     = "60s"
}

variable "alloydb_user" {
  type        = string 
  description = "Name of user" 
  default     = "alloydb-user"
}
variable "alloydb_password" {
  type        = string 
  description = "Password of user" 
  default     = "alloydbworkshop2023"
}

##----------------------------------------------------------------------------
## Create GCE Instance 

# Custom properties with defaults 
variable "gce_name" {
  type        = string 
  description = "Name of the GCE"
  default     = "instance-1" 
}

# Custom properties with defaults 
variable "gce_machine_type" {
  type        = string 
  description = "Machine type to use for GCE"
  default     = "e2-standard-2" 
}

# Custom properties with defaults 
variable "gce_tags" {
  type        = list(string)
  description = "GCE virtual machine tags"
  default     = ["lab-vm"]
}

# Custom properties with defaults 
variable "gce_machine_image" {
  type        = string
  description = "GCE virtual machine image"
  default     = "debian-cloud/debian-10"
}

# Custom properties with defaults 
variable "gce_machine_network" {
  type        = string
  description = "GCE virtual machine network"
  default     = "default"
}

# Custom properties with defaults 
variable "gce_scopes" {
  type        = list(string)
  description = "GCE service account scope"
  default     = ["cloud-platform"]
}

# Custom properties with defaults 
## The default setting uses compute developer service account
variable "gce_service_account" {
  type        = string
  description = "GCE Service Account"
  default     = "default" 
}

# Custom properties with defaults 
## The default Metadata setting 
variable "gce_metadata" {
  type        = map(string)
  description = "GCE Metadata object"
  default     = {"foo" = "bar"} 
}

# Custom properties with defaults 
variable "gce_startup_script" {
  type        = string
  description = "GCE startup script"
  default     = "apt-get install --yes postgresql-client" 
}

# Custom properties with defaults 
variable "gce_can_ip_forward" {
  type        = bool 
  description = "Allow IP forwarding"
  default     = "false" 
}
