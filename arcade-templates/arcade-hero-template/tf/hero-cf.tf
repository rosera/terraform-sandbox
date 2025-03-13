# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Cloud Run functions
#-----------------------------------------------------------------------------
variable "gcp_cf_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud_functions.png"
}

variable "gcp_cf_name" {
  type        = string
  description = "Cloud Run functions title"
  default     = "cf-demo"
}

variable "gcp_cf_generation" {
  type        = string
  description = "Cloud Run functions generation"
  default     = "2nd Gen"
}

variable "gcp_cf_runtime" {
  type        = string
  description = "Runtime language"
  default     = "Go"
}

variable "gcp_cf_trigger" {
  type        = string
  description = "Runtime language"
  default     = "Pub/Sub"
}

variable "gcp_cf_instances" {
  type        = string
  description = "Number of Cloud Run functions instances"
  default     = "5"
}


variable "gcp_cf_ref" {
  type        = string
  description = "Task Identifier"
  default     = "cr-7"
}

# Variables: Cloud Run functions 
#-----------------------------------------------------------------------------
module "cloud_functions_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Cloud Run functions 
  # Cloud Run functions: Create a Dataset 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = var.gcp_cf_ref 
  title         = "Create a Cloud Run functions"  
  image         = var.gcp_cf_icon  
  resource_name = "${var.gcp_cf_name}" 

  instructions = [  
    { step = "Navigate to the Cloud Run functions Page", command = "" },
    { step = "Click on the 'Create Function' button.", command = "" },
    { step = "Select the \"${var.gcp_cf_generation}\" option under the 'Environment' section.", command = "${var.gcp_cf_generation}" },
    { step = "Enter the name as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Under the Authentication heading, select \"Allow unauthenticated invocations\".", command = "" },
    { step = "Click the \"Runtime, build, connections and security settings\".", command = "" },
    { step = "Set the autoscaling maximum number of instances as \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}" },
    { step = "Set the runtime service account as \"Cloud Run functions demo account\" as the region.", command = ""  }, 
    { step = "Choose '${var.gcp_cf_runtime}' as the runtime language.", command = "${var.gcp_cf_runtime}" },
    { step = "Leave the entry point as the default for ${var.gcp_cf_runtime} runtime language.", command = ""  }, 
    { step = "Select an appropriate trigger for your function (e.g., HTTP, Cloud Pub/Sub, Cloud Storage, etc.).", command = "" },
    { step = "Enter the trigger as \"${var.gcp_cf_trigger}\".", command = "${var.gcp_cf_trigger}"  },  
    { step = "Enter the topic as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
    { step = "Click the 'Deploy' button to create your Gen 2 Cloud Run functions.", command = "" },
    { step = "The task is now complete.", command = ""  }
    # ... more instructions 
  ] 

  challenges = [  
    # { step = "Enable the Cloud Run functions API.", command = "" }, 
    { step = "Open the Cloud Run functions in the Google Cloud console.", command = "" }, 
    { step = "Select the \"${var.gcp_cf_generation}\" option under the 'Environment' section.", command = "${var.gcp_cf_generation}" },
    { step = "Enter the name as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Enter the trigger as \"${var.gcp_cf_trigger}\".", command = "${var.gcp_cf_trigger}"  },  
    { step = "Enter the topic as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
    { step = "Set the number of instances to \"${var.gcp_cf_instances}\" as the region.", command = "${var.gcp_cf_instances}"  }, 
    { step = "Set the runtime service account as \"Cloud Run functions demo account\" as the region.", command = ""  }, 
    { step = "Set the runtime language as \"${var.gcp_cf_runtime}\".", command = "${var.gcp_cf_runtime}"  }, 
    { step = "Leave the entry point as the default for ${var.gcp_cf_runtime} runtime language.", command = ""  }, 
    # ... more challenges 
  ] 

}
