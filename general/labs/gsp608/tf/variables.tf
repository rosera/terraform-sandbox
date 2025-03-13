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

variable "gcp_region_2" {
  type = string
  description = "Default region assigned to lab instance."
}

variable "gcp_region_3" {
  type = string
  description = "Default region assigned to lab instance."
}

variable "gcp_zone_2" {
  type = string
  description = "default zone assigned to lab instance."
}

variable "gcp_zone_3" {
  type = string
  description = "default zone assigned to lab instance."
}

# Internal 
#------------------------------------------------------------------------------

variable "vpc_one_name" {
  type        = string
  default     = "internal-network"
  description = "Network name"
}

variable "vpc_one_cidr" {
  type        = string
  default     = "10.0.0.0/24"
  description = "Network CIDR"
}

variable "fwr_one_name" {
  type        = string
  default     = "internal-allow-ssh"
  description = "Firewall name"
}

variable "fwr_one_source_range" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "Firewall source range CIDR"
}

variable "fwr_one_tags" {
  type        = list(any)
  default     = ["lab-vm"]
  description = "Firewall tags"
}

variable "fwr_one_priority" {
  type        = string
  default     = "1000"
  description = "Firewall priority"
}

variable "fwr_one_direction" {
  type        = string
  default     = "INGRESS"
  description = "Firewall rule direction"
}

variable "fwr_one_rule1_protocol" {
  type        = string
  default     = "tcp"
  description = "Firewall rule protocol"
}

variable "fwr_one_rule1_ports" {
  type        = list(any)
  default     = ["22"]
  description = "Firewall rule ports"
}

variable "gce_one_a_name" {
  type        = string
  default     = "internal-server-1"
  description = "GCE instance name"
}

variable "gce_one_b_name" {
  type        = string
  default     = "internal-server-2"
  description = "GCE instance name"
}


variable "gce_one_metadata" {
  type        = map(string)
  default     = null
  description = "GCE metadata object"
}

variable "gce_one_startup_script" {
  type        = string
  default     = null # "${file("./scripts/lab-init.sh")}"
  description = "GCE startup script"
}

variable "gce_one_machine_type" {
  type        = string
  default     = "e2-micro"
  description = "GCE machine type"
}

variable "gce_one_tags" {
  type        = list(any)
  default     = ["lab-vm"]
  description = "GCE instance tags"
}

variable "gce_one_machine_image" {
  type        = string
  default     = "debian-cloud/debian-11"
  description = "GCE machine image"
}

variable "gce_one_scopes" {
  type        = list(any)
  default     = ["cloud-platform"]
  description = "GCE scopes"
}

variable "gce_one_service_account" {
  type        = string
  default     = "default"
  description = "GCE service account"
}

# External 
#------------------------------------------------------------------------------

variable "vpc_two_name" {
  type        = string
  default     = "external-network"
  description = "Network name"
}

variable "vpc_two_cidr" {
  type        = string
  default     = "10.1.0.0/24"
  description = "Network CIDR"
}

variable "fwr_two_name" {
  type        = string
  default     = "external-allow-http"
  description = "Firewall name"
}

variable "fwr_two_source_range" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "Firewall source range CIDR"
}

variable "fwr_two_tags" {
  type        = list(any)
  default     = ["lab-vm"]
  description = "Firewall tags"
}

variable "fwr_two_priority" {
  type        = string
  default     = "1000"
  description = "Firewall priority"
}

variable "fwr_two_direction" {
  type        = string
  default     = "INGRESS"
  description = "Firewall rule direction"
}

variable "fwr_two_rule1_protocol" {
  type        = string
  default     = "tcp"
  description = "Firewall rule protocol"
}

variable "fwr_two_rule1_ports" {
  type        = list(any)
  default     = ["80"]
  description = "Firewall rule ports"
}

variable "gce_two_name" {
  type        = string
  default     = "external-server-1"
  description = "GCE instance name"
}

variable "gce_two_metadata" {
  type        = map(string)
  default     = null
  description = "GCE metadata object"
}

variable "gce_two_startup_script" {
  type = string
  default     = null # "${file("./scripts/lab-init.sh")}"
  description = "GCE startup script"
}

variable "gce_two_machine_type" {
  type        = string
  default     = "e2-micro"
  description = "GCE machine type"
}

variable "gce_two_tags" {
  type        = list(any)
  default     = ["lab-vm"]
  description = "GCE instance tags"
}

variable "gce_two_machine_image" {
  type        = string
  default     = "debian-cloud/debian-11"
  description = "GCE machine image"
}

variable "gce_two_scopes" {
  type        = list(any)
  default     = ["cloud-platform"]
  description = "GCE scopes"
}

variable "gce_two_service_account" {
  type        = string
  default     = "default"
  description = "GCE service account"
}

# Partner 
#------------------------------------------------------------------------------

variable "vpc_three_name" {
  type        = string
  default     = "partner-network"
  description = "Network name"
}

variable "vpc_three_cidr" {
  type        = string
  default     = "10.2.0.0/24"
  description = "Network CIDR"
}

variable "fwr_three_name" {
  type        = string
  default     = "partner-allow-rdp"
  description = "Firewall name"
}

variable "fwr_three_source_range" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "Firewall source range CIDR"
}

variable "fwr_three_tags" {
  type        = list(any)
  default     = ["lab-vm"]
  description = "Firewall tags"
}

variable "fwr_three_priority" {
  type        = string
  default     = "1000"
  description = "Firewall priority"
}

variable "fwr_three_direction" {
  type        = string
  default     = "INGRESS"
  description = "Firewall rule direction"
}

variable "fwr_three_rule1_protocol" {
  type        = string
  default     = "tcp"
  description = "Firewall rule protocol"
}

variable "fwr_three_rule1_ports" {
  type        = list(any)
  default     = ["3389"]
  description = "Firewall rule ports"
}

variable "gce_three_name" {
  type        = string
  default     = "partner-server-1"
  description = "GCE instance name"
}

variable "gce_three_metadata" {
  type        = map(string)
  default     = null
  description = "GCE metadata object"
}

variable "gce_three_startup_script" {
  type        = string
  default     = null # "${file("./scripts/lab-init.sh")}"
  description = "GCE startup script"
}

variable "gce_three_machine_type" {
  type        = string
  default     = "e2-micro"
  description = "GCE machine type"
}

variable "gce_three_tags" {
  type        = list(any)
  default     = ["lab-vm"]
  description = "GCE instance tags"
}

variable "gce_three_machine_image" {
  type        = string
  default     = "debian-cloud/debian-11"
  description = "GCE machine image"
}

variable "gce_three_scopes" {
  type        = list(any)
  default     = ["cloud-platform"]
  description = "GCE scopes"
}

variable "gce_three_service_account" {
  type        = string
  default     = "default"
  description = "GCE service account"
}
