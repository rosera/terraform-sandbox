# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Identity and Access Management
#-----------------------------------------------------------------------------
variable "gcp_iam_ref_1" {
  type        = string
  description = "Task Reference"
  default     = "iam-1"
}

variable "gcp_iam_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/identity_and_access_management.png"
}

variable "gcp_iam_role_1" {
  type        = string
  description = "IAM Role"
  default     = "Storage Admin"
}

variable "gcp_user_account" {
  type    = string
  default = "tester@gmail.com"
}

# Variables: IAM 
#-----------------------------------------------------------------------------
module "iam_bind_storage" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # IAM: Bind Storage Admin 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = var.gcp_iam_ref_1
  title      = "Apply an Storage role to an account"  
  image      = var.gcp_icon  
  resource_name = "${var.gcp_iam_role_1}" 

  instructions = [
    { step = "Go to the Google Cloud Console's IAM page.  You can find this by searching for 'IAM' in the console's search bar, or navigating through the menu (usually represented by three horizontal lines) and finding 'IAM & Admin' then 'IAM'.", "command": "TBC" },
    { step = "Select the project \"${var.gcp_project_id}\" where you want to apply the Storage Admin role.  The project selection dropdown is usually located at the top of the console.", "command": "TBC" },
    { step = "Click the 'GRANT ACCESS' button at the top of the IAM page.", "command": "TBC" },
#    { step = "In the 'New principals' field, enter the email address or Google account ID of the existing account \"${var.gcp_user_account}\" to grant the role to.", "command": "TBC" },
    { step = "In the 'New principals' field, enter the email address or Google account ID of the existing account \"tester@gmail.com\" to grant the role to.", "command": "TBC" },
    { step = "Click the 'Select a role' dropdown menu.", "command": "TBC" },
    { step = "Search for '${var.gcp_iam_role_1}' or navigate through the role hierarchy to find it.  It's usually located under 'Cloud Storage'.", "command": "TBC" },
    { step = "Select the '${var.gcp_iam_role_1}' role.", "command": "TBC" },
    { step = "Click the 'Save' button.  This will grant the role to the specified account for the selected project.", "command": "TBC" },
    { step = "The task is now complete.", command = ""  },  
  ]

  challenges = [  
    { step = "Go to the Google Cloud Console's IAM page.", "command": "TBC" },
#    { step = "Enter the email address or Google account ID of the existing account \"${var.gcp_user_account}\" to grant the role to.", "command": "TBC" },
    { step = "Enter the email address or Google account ID of the existing account \"tester@gmail.com\" to grant the role to.", "command": "TBC" },
    { step = "Select the '${var.gcp_iam_role_1}' role.", "command": "TBC" },
    { step = "Click the 'Save' button.", "command": "TBC" },
    # ... more challenges 
  ] 

}

# Variables: Identity and Access Management
#-----------------------------------------------------------------------------
variable "gcp_iam_ref_2" {
  type        = string
  description = "Task Reference"
  default     = "iam-2"
}

## variable "gcp_icon" {
##   type        = string
##   description = "key file location"
##   default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/identity_and_access_management.png"
## }

variable "gcp_iam_role_2" {
  type        = string
  description = "IAM Role"
  default     = "Compute Admin"
}

# Variables: IAM 
#-----------------------------------------------------------------------------
module "iam_bind_compute" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # IAM: Bind Storage Admin 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = var.gcp_iam_ref_2
  title      = "Apply an Compute role to an account"  
  image      = var.gcp_icon  
  resource_name = "${var.gcp_iam_role_2}" 

  instructions = [
    { step = "Go to the Google Cloud Console's IAM page.  You can find this by searching for 'IAM' in the console's search bar, or navigating through the menu (usually represented by three horizontal lines) and finding 'IAM & Admin' then 'IAM'.", "command": "TBC" },
    { step = "Select the project \"${var.gcp_project_id}\" where you want to apply the Storage Admin role.  The project selection dropdown is usually located at the top of the console.", "command": "TBC" },
    { step = "Click the 'GRANT ACCESS' button at the top of the IAM page.", "command": "TBC" },
#    { step = "In the 'New principals' field, enter the email address or Google account ID of the existing account \"${var.gcp_user_account}\" to grant the role to.", "command": "TBC" },
    { step = "In the 'New principals' field, enter the email address or Google account ID of the existing account \"tester@gmail.com\" to grant the role to.", "command": "TBC" },
    { step = "Click the 'Select a role' dropdown menu.", "command": "TBC" },
    { step = "Search for '${var.gcp_iam_role_2}' or navigate through the role hierarchy to find it.  It's usually located under 'Cloud Storage'.", "command": "TBC" },
    { step = "Select the '${var.gcp_iam_role_2}' role.", "command": "TBC" },
    { step = "Click the 'Save' button.  This will grant the role to the specified account for the selected project.", "command": "TBC" },
    { step = "The task is now complete.", command = ""  },  
  ]

  challenges = [  
    { step = "Go to the Google Cloud Console's IAM page.", "command": "TBC" },
#    { step = "Enter the email address or Google account ID of the existing account \"${var.gcp_user_account}\" to grant the role to.", "command": "TBC" },
    { step = "Enter the email address or Google account ID of the existing account \"tester@gmail.com\" to grant the role to.", "command": "TBC" },
    { step = "Select the '${var.gcp_iam_role_2}' role.", "command": "TBC" },
    { step = "Click the 'Save' button.", "command": "TBC" },
    # ... more challenges 
  ] 

}
