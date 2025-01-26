# GCS Task Module
# Platform Variables: Qwiklabs defined variables settings 
#-----------------------------------------------------------------------------

variable "project_id" {
  type = string
  description = "GCP Project ID"
}

variable "region" {
  type = string
  description = "GCP Region"
}

variable "zone" {
  type = string
  description = "GCP Zone"
}

# User Variables: Content author values 
#-----------------------------------------------------------------------------

variable "ref" {
  type = string
  description = "Resource Reference ID"
}

variable "title" {
  type = string
  description = "Resource title"
}

variable "image" {
  type = string
  description = "Resource image"
}

variable "resource_name" {
  type = string
  description = "Resource name"
}

variable "challenges" {
  type = list(object({
    step = string
    command = string
  }))
  description = "Lab Challenge steps"
}

variable "instructions" {
  type = list(object({
    step = string
    command = string
  }))
  description = "Lab Instruction steps"
}
