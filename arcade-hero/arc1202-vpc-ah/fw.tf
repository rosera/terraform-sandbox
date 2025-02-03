# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

variable "gcp_fw_1_name" {
  type        = string
  description = "VPC name"
  default     = "default-allow-inbound"
}

variable "gcp_fw_1_direction1_name" {
  type        = string
  description = "Firewall traffic direction"
  default     = "Ingress"
}

variable "gcp_fw_1_source1_cidr" {
  type        = string
  description = "Firewall source range"
  default     = "0.0.0.0/0"
}

variable "gcp_fw_1_target1_tag" {
  type        = string
  description = "Firewall target tag"
  default     = "staging-vm"
}

variable "gcp_fw_1_target2_tag" {
  type        = string
  description = "Firewall target tag"
  default     = "prod-vm"
}

# Variables: Google VPC 
#-----------------------------------------------------------------------------
module "fw_sourcetag_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Virtual Private Cloud 
  # Virtual Private Cloud: Create a Network 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "fw-1"
  title         = "Create an Firewall Rule with Source Tag"
  image         = var.gcp_icon 
  resource_name = "${var.gcp_fw_1_name}"

  challenges = [
    { step = "Click the 'CREATE FIREWALL RULE' button.", command = "" },
    { step = "Name the firewall rule a descriptive name (e.g., '${var.gcp_fw_1_name}').", command = "${var.gcp_fw_1_name}" },
    { step = "Network: Ensure the 'default' VPC network is selected.", command = "" },
    { step = "Direction of traffic: Select '${var.gcp_fw_1_direction1_name}' for traffic direction.", command = "${var.gcp_fw_1_direction1_name}" },
    # { step = "Targets: Choose how to apply the rule: \"All instances in the network\".", command = "" },
    { step = "Targets: Choose how to apply the rule: \"Specified target tags\".", command = "" },
    { step = "Add the target: \"${var.gcp_fw_1_target1_tag}\".", command = "${var.gcp_fw_1_target1_tag}" },
    { step = "Source IP ranges: Enter the IP address range (in CIDR notation) to allow traffic from (e.g., '${var.gcp_fw_1_source1_cidr}' for all addresses).", command = "${var.gcp_fw_1_source1_cidr}" },
    { step = "Protocols and ports: Select 'Specified protocols and ports', then specify the desired protocol (e.g., 'tcp') and port (e.g., '80' for HTTP).", command = ""},
    # ... more challenges
  ]

  instructions = [
    { step = "Go to the VPC Firewall Rules page in the Google Cloud Console. You can find this by searching for 'Firewall' or navigating to VPC Network -> Firewall.", command = ""}, 
    { step = "Click the 'CREATE FIREWALL RULE' button.", command = "" },
    { step = "Name the firewall rule a descriptive name (e.g., '${var.gcp_fw_1_name}').", command = "${var.gcp_fw_1_name}" },
    { step = "Network: Ensure the 'default' VPC network is selected.", command = "" },
    { step = "Priority: Assign a priority (1000 is the default). Lower numbers have higher priority.", command = "" },
    { step = "Direction of traffic: Select '${var.gcp_fw_1_direction1_name}' for traffic direction.", command = "${var.gcp_fw_1_direction1_name}" },
    { step = "Action on match: Select 'Allow' to permit traffic matching the rule's criteria.", command = "" },
    #{ step = "Targets: Choose how to apply the rule: \"All instances in the network\".", command = "" },
    # { step = "Targets: Choose how to apply the rule: \"Specify target tags\", \"Specify target service accounts\", or \"All instances in the network\".", command = "" },
    { step = "Targets: Choose how to apply the rule: \"Specified target tags\".", command = "" },
    { step = "Add the target: \"${var.gcp_fw_1_target1_tag}\".", command = "${var.gcp_fw_1_target1_tag}" },
    { step = "Source filter: Select 'IP ranges' for inbound rules.", command = "" },
    { step = "Source IP ranges: Enter the IP address range (in CIDR notation) to allow traffic from (e.g., '${var.gcp_fw_1_source1_cidr}' for all addresses).", command = "${var.gcp_fw_1_source1_cidr}" },
    { step = "Protocols and ports: Select 'Specified protocols and ports', then specify the desired protocol (e.g., 'tcp') and port (e.g., '80' for HTTP).", command = ""},
    { step = "Click the 'Create' button to save your firewall rule.", command = ""}, 
    { "step": "Wait for the VPC network to be created. A notification message will appear at the bottom of the screen once the action is complete.", "command": "" },

    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]
}
