## --------------------------------------------------------------
## Mandatory variable definitions
## --------------------------------------------------------------

variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to create resources in."
}

# Default value passed in
variable "gcp_region" {
  type        = string
  description = "Region to create resources in."
}

# Default value passed in
variable "gcp_zone" {
  type        = string
  description = "Zone to create resources in."
}

## --------------------------------------------------------------
## Output variable definitions - Override from Custom Properties 
## --------------------------------------------------------------
## Ensure these values are defined in Qwiklabs.yaml

# with the same name for any lab that uses this script.
variable "gcp_username" {
  type        = string
  description = "Name of Qwiklabs user"
}

## --------------------------------------------------------------
## Custom variable definitions - Override from Custom Properties
## --------------------------------------------------------------
# Custom properties with defaults 
variable "vpcConnectorMachineType" {
  type        = string 
  description = "VPC Access Connector Machine Type"
  default     = "f1-micro" 
}

variable "gcrRegion" {
  type        = string
  description = "GCE virtual machine image family"
}

variable "gceMachineImage" {
  type        = string
  description = "GCE virtual machine image family"
#  default     = "ide-codeserver"
  default     = "debian-cloud/debian-10"
}

variable "gceProjectMachineImage" {
  type        = string
  description = "Project hosting the image family"
  default     = "qwiklabs-resources"
}

variable "gceInstanceName" {
  type        = string
  description = "GCE virtual machine image family"
  default     = "cloudlearningservices"
}

# Custom properties with defaults 
variable "gceInstanceZone" {
  type        = string 
  description = "Zone to create resources in."
}

# Custom properties with defaults 
variable "gceInstanceTags" {
  type        = list(string)
  description = "GCE virtual machine tags"
  default     = ["lab-vm"]
}

# Custom properties with defaults 
variable "gceMachineType" {
  type        = string 
  description = "Machine type to use for GCE"
  default     = "e2-standard-2" 
}

# Custom properties with defaults 
variable "gceInstanceNetwork" {
  type        = string
  description = "GCE virtual machine network"
  default     = "default"
}

# Custom properties with defaults 
variable "gceInstanceScope" {
  type        = list(string)
  description = "GCE service account scope"
  default     = ["cloud-platform"]
}
