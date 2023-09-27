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

#
# ------------------  Custom Properties
#
variable "allowed_regions" {
  type = list 
  description = "List of Regions to be used"
  default = ["us-central1", "us-east1", "us-east4", "us-west1" ]
}
