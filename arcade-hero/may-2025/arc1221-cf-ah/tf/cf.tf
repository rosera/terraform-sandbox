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
  default     = "cf-go"
}

variable "gcp_cf2_name" {
  type        = string
  description = "Cloud Run functions title"
  default     = "cf-pubsub"
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
  description = "Event Trigger"
  default     = "HTTP"
}

variable "gcp_cf2_trigger" {
  type        = string
  description = "Runtime language"
  default     = "Pub/Sub trigger"
}

variable "gcp_cf_entrypoint" {
  type        = string
  description = "Runtime language"
  default     = "HelloHTTP"
}

variable "gcp_cf_instances" {
  type        = string
  description = "Number of Cloud Run function instances"
  default     = "5"
}

variable "gcp_cf_service_account" {
  type        = string
  description = "Cloud Run functions service account"
  # default     = "Compute Engine default service account"
  # default     = "Cloud Run functions demo account"
  default     = "Arcade Hero SA"
}

variable "gcp_cf2_service_account" {
  type        = string
  description = "Cloud Run functions service account"
  default     = "Compute Engine default service account"
  # default     = "Cloud Run functions demo account"
  # default     = "Arcade Hero SA"
}


# Variables: Cloud Run functions 
#-----------------------------------------------------------------------------
# module "cloud_functions_http" {
#   # TODO: Move source to terraform-lab-foundations
#   source = "./modules/arcade_task"
# 
#   # ... Cloud Run functions 
#   # Cloud Run functions: Create a Dataset 
#   project_id = var.gcp_project_id
#   region     = var.gcp_region
#   zone       = var.gcp_zone
# 
#   ref           = "cf-1"
#   title         = "Create a Cloud Run function with HTTP trigger"  
#   image         = var.gcp_cf_icon  
#   resource_name = "${var.gcp_cf_name}" 
# 
#   instructions = [  
#     { step = "Navigate to the Cloud Run functions Page", command = "" },
#     { step = "Click on the 'Create Function' button.", command = "" },
#     { step = "Select the \"${var.gcp_cf_generation}\" option under the 'Environment' section.", command = "${var.gcp_cf_generation}" },
#     { step = "Enter the name as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
#     { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
#     { step = "Under the Authentication heading, select \"Allow unauthenticated invocations\".", command = "" },
#     { step = "Click the \"Runtime, build, connections and security settings\".", command = "" },
#     { step = "Set the autoscaling maximum number of instances as \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}" },
#     { step = "Choose '${var.gcp_cf_runtime}' as the runtime language.", command = "${var.gcp_cf_runtime}" },
#     { step = "Leave the entry point as the default for ${var.gcp_cf_runtime} runtime language.", command = ""  }, 
#     { step = "Select an appropriate trigger for your function (e.g., HTTP, Cloud Pub/Sub, Cloud Storage, etc.).", command = "" },
#     { step = "Enter the trigger as \"${var.gcp_cf_trigger}\".", command = "${var.gcp_cf_trigger}"  },  
#     { step = "Click the 'Deploy' button to create your Gen 2 Cloud Run function.", command = "" },
#     { step = "The task is now complete.", command = ""  }
#     # ... more instructions 
#   ] 
# 
#   challenges = [  
#     # { step = "Enable the Cloud Run functions API.", command = "" }, 
#     { step = "Open the Cloud Run functions in the Google Cloud console.", command = "" }, 
#     { step = "Select the \"${var.gcp_cf_generation}\" option under the 'Environment' section.", command = "${var.gcp_cf_generation}" },
#     { step = "Enter the name as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
#     { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
#     { step = "Enter the trigger as \"${var.gcp_cf_trigger}\".", command = "${var.gcp_cf_trigger}"  },  
#     { step = "Set the number of instances to \"${var.gcp_cf_instances}\" as the region.", command = "${var.gcp_cf_instances}"  }, 
#     { step = "Set the runtime language as \"${var.gcp_cf_runtime}\".", command = "${var.gcp_cf_runtime}"  }, 
#     { step = "Leave the entry point as the default for ${var.gcp_cf_runtime} runtime language.", command = ""  }, 
#     # ... more challenges 
#   ] 
# 
# }

module "cloud_functions_http" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Cloud Run functions 
  # Cloud Run functions: Create a Dataset 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "cf-1"
  title         = "Create a Cloud Run function with HTTP trigger"  
  image         = var.gcp_cf_icon  
  resource_name = "${var.gcp_cf_name}" 

  instructions = [  
    { step = "Navigate to the Cloud Run functions Page", command = "" },
    { step = "Click on the 'Write a function' button.", command = "" },
    #    { step = "Click on the 'Create Function' button.", command = "" },
    { step = "Select the \"Function\" option 'Use an inline editor to create a function' section.", command = "" },
    { step = "Enter the service name as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  

    #    { step = "Select the \"${var.gcp_cf_generation}\" option under the 'Environment' section.", command = "${var.gcp_cf_generation}" },
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Choose '${var.gcp_cf_runtime}' as the runtime language.", command = "${var.gcp_cf_runtime}" },
    { step = "Under the \"Authentication\" heading, select \"Allow unauthenticated invocations\".", command = "" },
    #    { step = "Click the \"Runtime, build, connections and security settings\".", command = "" },
    { step = "Access the \"Container (s), Volumes, Networking, Security\" section.", command = ""  }, 
    { step = "Use the \"Container\" Tab section to set the maximum number of instances to \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}"  }, 

    { step = "Use the \"Security\" Tab section to set the service acccount.", command = ""  }, 
    { step = "Set the service account to \"${var.gcp_cf_service_account}\".", command = "${var.gcp_cf_service_account}"  }, 
    #    { step = "Set the autoscaling maximum number of instances as \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}" },
    #    { step = "Leave the entry point as the default for ${var.gcp_cf_runtime} runtime language.", command = ""  }, 
    #    { step = "Select an appropriate trigger for your function (e.g., HTTP, Cloud Pub/Sub, Cloud Storage, etc.).", command = "" },
    #    { step = "Enter the trigger as \"${var.gcp_cf_trigger}\".", command = "${var.gcp_cf_trigger}"  },  
    { step = "Click the 'Create' button to create your Cloud Run function.", command = "" },
    { step = "The task is now complete.", command = ""  }
    # ... more instructions 
  ] 

  challenges = [  
    # { step = "Enable the Cloud Run functions API.", command = "" }, 
    { step = "Open the Cloud Run functions in the Google Cloud console.", command = "" }, 
    { step = "Click on the 'Write a function' button.", command = "" },
    { step = "Select the \"Function\" option 'Use an inline editor to create a function' section.", command = "" },
    { step = "Enter the service name as \"${var.gcp_cf_name}\".", command = "${var.gcp_cf_name}"  },  
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Set the runtime language as \"${var.gcp_cf_runtime}\".", command = "${var.gcp_cf_runtime}"  }, 
    #    { step = "Enter the trigger as \"${var.gcp_cf_trigger}\".", command = "${var.gcp_cf_trigger}"  },  
    { step = "Set the \"Authentication\" to \"Allow unauthenticated invocation\".", command = ""  }, 
    { step = "Access the \"Container (s), Volumes, Networking, Security\" section.", command = ""  }, 
    { step = "Use the \"Container\" Tab section to set the maximum number of instances to \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}"  }, 
    { step = "Use the \"Security\" Tab section to set the service acccount.", command = ""  }, 
    { step = "Set the service account to \"${var.gcp_cf_service_account}\".", command = "${var.gcp_cf_service_account}"  }, 
    #    { step = "Leave the entry point as the default for ${var.gcp_cf_runtime} runtime language.", command = ""  }, 
    { step = "Click the 'Create' button to create your Cloud Run function.", command = "" },
    # ... more challenges 
  ] 

}

module "cloud_functions_pubsub" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Cloud Run functions
  # Cloud Run functions: Create a Dataset
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "cf-2"
  title         = "Create a Cloud Run functions"
  image         = var.gcp_cf_icon
  resource_name = "${var.gcp_cf_name}"

  instructions = [
    { step = "Navigate to the Cloud Run functions Page", command = "" },
    { step = "Click on the 'Write a function' button.", command = "" },
    { step = "Select the \"Function\" option 'Use an inline editor to create a function' section.", command = "" },
    { step = "Enter the service name as \"${var.gcp_cf2_name}\".", command = "${var.gcp_cf2_name}"  },  
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Set the runtime language as \"${var.gcp_cf_runtime}\".", command = "${var.gcp_cf_runtime}"  }, 
    { step = "Enter the trigger as \"${var.gcp_cf2_trigger}\".", command = "${var.gcp_cf2_trigger}"  },  
    { step = "If an API notification is shown, follow the onscreen instruction to enable the required API is enabled.", command = ""  }, 
    { step = "Use the Trigger defaults as set by the system.", command = ""  },  
    { step = "Create the PubSub Topic name as \"arcade-hero\" in region \"${var.gcp_region}\".", command = "arcade-hero"  },  
    { step = "Set the service account to \"${var.gcp_cf2_service_account}\".", command = "${var.gcp_cf2_service_account}"  }, 
    { step = "Click the 'Save trigger' button to create the event.", command = "" },
    { step = "Set the \"Authentication\" to \"Require authentication\".", command = ""  }, 
    # { step = "Set the \"Authentication\" to \"Allow unauthenticated invocation\".", command = ""  }, 
    { step = "Access the \"Container (s), Volumes, Networking, Security\" section.", command = ""  }, 
    { step = "Use the \"Container\" section to set the maximum number of instances to \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}"  }, 
    { step = "Use the \"Security\" section to set the service account to \"${var.gcp_cf2_service_account}\".", command = "${var.gcp_cf2_service_account}"  }, 
    { step = "The task is now complete.", command = ""  }
    # ... more instructions
  ]

  challenges = [
    { step = "Navigate to the Cloud Run functions Page", command = "" },
    { step = "Click on the 'Write a function' button.", command = "" },
    { step = "Select the \"Function\" option 'Use an inline editor to create a function' section.", command = "" },
    { step = "Enter the service name as \"${var.gcp_cf2_name}\".", command = "${var.gcp_cf2_name}"  },  
    { step = "Select \"${var.gcp_region}\" as the region.", command = "${var.gcp_region}"  }, 
    { step = "Set the runtime language as \"${var.gcp_cf_runtime}\".", command = "${var.gcp_cf_runtime}"  }, 
    { step = "Enter the trigger as \"${var.gcp_cf2_trigger}\".", command = "${var.gcp_cf2_trigger}"  },  
    { step = "If an API notification is shown, follow the onscreen instruction to enable the required API is enabled.", command = ""  }, 
    { step = "Use the Trigger defaults as set by the system.", command = ""  },  
    { step = "Create the PubSub Topic name as \"arcade-hero\" in region \"${var.gcp_region}\".", command = "arcade-hero"  },  
    { step = "Set the service account to \"${var.gcp_cf2_service_account}\".", command = "${var.gcp_cf2_service_account}"  }, 
    { step = "Click the 'Save trigger' button to create the event.", command = "" },
    { step = "Set the \"Authentication\" to \"Require authentication\".", command = ""  }, 
    # { step = "Set the \"Authentication\" to \"Allow unauthenticated invocation\".", command = ""  }, 
    { step = "Access the \"Container (s), Volumes, Networking, Security\" section.", command = ""  }, 
    { step = "Use the \"Container\" section to set the maximum number of instances to \"${var.gcp_cf_instances}\".", command = "${var.gcp_cf_instances}"  }, 
    { step = "Use the \"Security\" section to set the service account to \"${var.gcp_cf2_service_account}\".", command = "${var.gcp_cf2_service_account}"  }, 
    { step = "The task is now complete.", command = ""  }

    # ... more challenges
  ]

}
