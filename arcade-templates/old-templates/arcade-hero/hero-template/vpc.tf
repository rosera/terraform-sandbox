# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

variable "gcp_vpc_1_name" {
  type        = string
  description = "VPC name"
  default     = "staging"
}

# Variables: Google VPC 
#-----------------------------------------------------------------------------
module "vpc_network_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Virtual Private Cloud 
  # Virtual Private Cloud: Create a Network 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "vpc-1"
  title         = "Create a Virtual Private Cloud"
  image         = var.gcp_icon 
  resource_name = "${var.gcp_vpc_1_name}"

  challenges = [
    { step = "Create a custom VPC network", command = "" },
    { step = "Name the VPC network as \"${var.gcp_vpc_1_name}\".", command = "${var.gcp_vpc_1_name}" },
    { step = "Do not create a subnet.", command = "" },
    { step = "Do not add any Firewall rules.", command = "" },
    # ... more challenges
  ]

  instructions = [
    { "step": "Access the VPC Networks page in the Google Cloud console.", "command": "" },
    { "step": "Navigate to the VPC Networks section within your Google Cloud project.", "command": "" },
    { "step": "Click \"CREATE VPC NETWORK\". This button will initiate the VPC network creation process.", "command": "" },
    { "step": "Enter the name \"${var.gcp_vpc_1_name}\" for your new VPC network.", "command": "${var.gcp_vpc_1_name}" },
    { "step": "Select \"Custom\" subnet creation mode. This option allows you to define your own subnets and their IP address ranges.", "command": "" },
    { "step": "Select the subnet delete icon to remove this configuration from the VPC.", "command": "" },
    # { "step": "Create a subnet:**  Provide the following details:", "command": "" }, 
    # { "step": "Subnet name:** A descriptive name for your subnet.", "command": "" }, 
    # { "step": "Region:** The geographical region where you want the subnet located..", "command": "" }, 
    # { "step": "IP address range:**  A valid CIDR block for the subnet (e.g., 10.0.1.0/24).", "command": "10.0.1.0/24" }, 
    # { "step": "Add more subnets (optional):** If needed, create additional subnets in different regions or with different IP address ranges.", "command": "" },
    # { "step": "Configure firewall rules (optional):**  You can choose to add firewall rules immediately to control inbound and outbound traffic within the VPC.", "command": "" }, 
    # { "step": "Select 'Dynamic' routing mode:**  This is generally recommended for flexible VPC setups.", "command": "" },
    { "step": "Click the \"CREATE\" button at the bottom of the screen. Verify your configuration and then click 'Create' to finalize the VPC network setup.", "command": "" },
    { "step": "Wait for the VPC network to be created. A notification message will appear at the bottom of the screen once the action is complete.", "command": "" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]
}

variable "gcp_vpc_2_name" {
  type        = string
  description = "VPC name"
  default     = "development"
}

variable "gcp_vpc_2_subnet_1_name" {
  type        = string
  description = "Subnet name"
  default     = "dev-1"
}

variable "gcp_vpc_2_subnet_2_cidr" {
  type        = string
  description = "Subnet cidr"
  default     = "10.1.0.0/24"
}

# Variables: Google VPC 
#-----------------------------------------------------------------------------
module "vpc_subnet_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Virtual Private Cloud 
  # Virtual Private Cloud: Create a Network 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "vpc-2"
  title         = "Create a custom Virtual Private Cloud"
  image         = var.gcp_icon 
  resource_name = "${var.gcp_vpc_2_name}"

  challenges = [
    { step = "Name the custom VPC network as \"${var.gcp_vpc_2_name}\".", command = "${var.gcp_vpc_2_name}" },
    { step = "Create a subnet as \"${var.gcp_vpc_2_subnet_1_name}\".", command = "${var.gcp_vpc_2_subnet_1_name}" },
    { step = "Set the subnet region: \"${var.gcp_region}\"", "command": "${var.gcp_region}" }, 
    { step = "Add a valid CIDR block for the subnet (e.g., ${var.gcp_vpc_2_subnet_2_cidr}).", "command": "${var.gcp_vpc_2_subnet_2_cidr}" }, 
    { step = "Do not add any Firewall rules.", command = "" },
    # ... more challenges
  ]

  instructions = [
    { "step": "Access the VPC Networks page in the Google Cloud console.", "command": "" },
    { "step": "Navigate to the VPC Networks section within your Google Cloud project.", "command": "" },
    { "step": "Click \"CREATE VPC NETWORK\". This button will initiate the VPC network creation process.", "command": "" },
    { "step": "Enter the name \"${var.gcp_vpc_2_name}\" for your new VPC network.", "command": "${var.gcp_vpc_2_name}" },
    { "step": "Select \"Custom\" subnet creation mode. This option allows you to define your own subnets and their IP address ranges.", "command": "" },
    # { "step": "Select the subnet delete icon to remove this configuration from the VPC.", "command": "" },
    # { "step": "Create a subnet:**  Provide the following details:", "command": "" }, 
    { "step": "Enter the subnet name as \"${var.gcp_vpc_2_subnet_1_name}\" for your new subnetwork.", "command": "${var.gcp_vpc_2_subnet_1_name}" },
    # { "step": "Subnet name:  descriptive name for your subnet.", "command": "" }, 
    { "step": "Assign the Region as \"${var.gcp_region}\"", "command": "${var.gcp_region}" }, 
    { "step": "Add a valid CIDR block for the subnet (e.g., ${var.gcp_vpc_2_subnet_2_cidr}).", "command": "${var.gcp_vpc_2_subnet_2_cidr}" }, 
    # { "step": "Add more subnets (optional):** If needed, create additional subnets in different regions or with different IP address ranges.", "command": "" },
    # { "step": "Configure firewall rules (optional):**  You can choose to add firewall rules immediately to control inbound and outbound traffic within the VPC.", "command": "" }, 
    # { "step": "Select 'Dynamic' routing mode:**  This is generally recommended for flexible VPC setups.", "command": "" },
    { "step": "Click the \"CREATE\" button at the bottom of the screen. Verify your configuration and then click 'Create' to finalize the VPC network setup.", "command": "" },
    { "step": "Wait for the VPC network to be created. A notification message will appear at the bottom of the screen once the action is complete.", "command": "" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]
}
