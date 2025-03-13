# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Artifact Registry
#-----------------------------------------------------------------------------
variable "gcp_task_ref" {
  type        = string
  description = "Task Reference"
  default     = "ar-8"
}

variable "gcp_ar_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/artifact_registry.png"
}

variable "gcp_ar_name" {
  type        = string
  description = "Artifact Registry title"
  default     = "prod-registry"
}

variable "gcp_ar_type" {
  type        = string
  description = "Artifact Registry title"
  default     = "DOCKER"
}

variable "gcp_ar_policy" {
  type        = string
  description = "Artifact cleanup policy name"
  default     = "Grandfather"
}

variable "gcp_ar_keep" {
  type        = string
  description = "Artifact cleanup policy keep count"
  default     = "3"
}

# Variables: Artifact Registry 
#-----------------------------------------------------------------------------
module "ar_repo_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Artifact Registry 
  # Artifact Registry: Create a Dataset 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = var.gcp_task_ref
  title      = "Create a Artifact Registry"  
  image      = var.gcp_ar_icon  
  resource_name = "${var.gcp_ar_name}" 

  instructions = [  
    { step = "Enable the Artifact Registry API.", command = "" }, 
    { step = "Open the Artifact Registry in the Google Cloud console.", command = "" }, 
    { step = "Click the \"Create Repository\" button.", command = ""  },  
    { step = "Enter the name as \"${var.gcp_ar_name}\".", command = "${var.gcp_ar_name}"  },  
    { step = "Set the format as \"${var.gcp_ar_type}\".", command = ""  }, 
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Select \"New cleanup policy\".", command = ""  }, 
    { step = "Set the name as \"${var.gcp_ar_policy}\".", command = "${var.gcp_ar_policy}"  }, 
    { step = "Click the policy type radio button \"Keep most recent versions\".", command = ""  }, 
    { step = "Enter the \"Keep count\" value as \"${var.gcp_ar_keep}\".", command = "${var.gcp_ar_keep}"  }, 
    { step = "Click the \"CREATE\" button.", command = ""  }, 
    { step = "The task is now complete.", command = ""  },  
    # ... more instructions 
  ] 

  challenges = [  
    { step = "Enable the Artifact Registry API.", command = "" }, 
    { step = "Open the Artifact Registry in the Google Cloud console.", command = "" }, 
    { step = "Enter the name as \"${var.gcp_ar_name}\".", command = "${var.gcp_ar_name}"  },  
    { step = "Set the format as \"${var.gcp_ar_type}\".", command = ""  }, 
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Set the name as \"${var.gcp_ar_policy}\".", command = "${var.gcp_ar_policy}"  }, 
    { step = "Enter the \"Keep count\" value as \"${var.gcp_ar_keep}\".", command = "${var.gcp_ar_keep}"  }, 
    # ... more challenges 
  ] 

}
