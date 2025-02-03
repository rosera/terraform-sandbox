# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Cloud Run 
#-----------------------------------------------------------------------------
variable "gcp_cr_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud_run.png"
}

variable "gcp_cr_1_name" {
  type        = string
  description = "Cloud Run name"
  default     = "private-backend"
}

variable "gcp_cr_2_name" {
  type        = string
  description = "Cloud Run name"
  default     = "public-frontend"
}

# Variables: Cloud Run 
#-----------------------------------------------------------------------------
module "cr_private_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Cloud Run 
  # Cloud Run: Create a Service 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = "cr-1"
  title      = "Create a private Cloud Run service"  
  image      = var.gcp_cr_icon  
  resource_name = "${var.gcp_cr_1_name}" 

  instructions = [  

    { step = "Find the project labelled \"${var.gcp_project_id}\".", command = "" },  
    { step = "In your Google Cloud Console, navigate to the Cloud Run section.", command = "TBC" },
    { step = "Click on the 'Create Service' button to initiate the service creation process.", command = "TBC" },
    { step = "Specify \"${var.gcp_cr_1_name}\" as a unique name for your Cloud Run service.", command = "TBC" },
    { step = "Choose the region where you want to deploy your service as \"${var.gcp_region}\".", command = ""  }, 
#    { step = "Select 'Go' as your runtime language.", command = "TBC" },
    { step = "Set the container image URL. This URL points to the Container image of your Go application.", command = "TBC" },
#    { step = "Configure any necessary environment variables for your Go application.", command = "TBC" },
#    { step = "Adjust the memory limit, CPU allocation, and concurrency settings according to your application's requirements.", command = "TBC" },
    { step = "Set up ingress settings as 'Require Authentication'.", command = "TBC" },
    { step = "Review the service configuration and click 'Create' to deploy your Cloud Run service.", command = "TBC" },
    { step = "Wait for the deployment to complete. Once finished, the service URL will be displayed, allowing you to access your Go application running on Cloud Run.", command = "TBC" },
    { step = "The task is now complete.", command = ""  },  

    # ... more instructions 
  ] 

  challenges = [  
    { step = "In your Google Cloud Console, navigate to the Cloud Run section.", command = "TBC" },
    { step = "Click on the 'Create Service' button to initiate the service creation process.", command = "TBC" },
    { step = "Specify \"${var.gcp_cr_1_name}\" as a unique name for your Cloud Run service.", command = "TBC" },
    { step = "Set up ingress settings as 'Require Authentication'.", command = "TBC" },
    { step = "Review the service configuration and click 'Create' to deploy your Cloud Run service.", command = "TBC" },
    { step = "The task is now complete.", command = ""  },  

    # ... more challenges 
  ] 

}

module "cr_public_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Cloud Run 
  # Cloud Run: Create a Service 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = "cr-2"
  title      = "Create a public Cloud Run service"  
  image      = var.gcp_cr_icon  
  resource_name = "${var.gcp_cr_2_name}" 

  instructions = [  

    { step = "Find the project labelled \"${var.gcp_project_id}\".", command = "" },  
    { step = "In your Google Cloud Console, navigate to the Cloud Run section.", command = "TBC" },
    { step = "Click on the 'Create Service' button to initiate the service creation process.", command = "TBC" },
    { step = "Specify \"${var.gcp_cr_2_name}\" as a unique name for your Cloud Run service.", command = "TBC" },
    { step = "Choose the region where you want to deploy your service as \"${var.gcp_region}\".", command = ""  }, 
#    { step = "Select 'Go' as your runtime language.", command = "TBC" },
    { step = "Set the container image URL. This URL points to the Container image of your Go application.", command = "TBC" },
#    { step = "Configure any necessary environment variables for your Go application.", command = "TBC" },
#    { step = "Adjust the memory limit, CPU allocation, and concurrency settings according to your application's requirements.", command = "TBC" },
    { step = "Set up ingress settings as 'Allow all traffic'.", command = "TBC" },
    { step = "Review the service configuration and click 'Create' to deploy your Cloud Run service.", command = "TBC" },
    { step = "Wait for the deployment to complete. Once finished, the service URL will be displayed, allowing you to access your Go application running on Cloud Run.", command = "TBC" },
    { step = "The task is now complete.", command = ""  },  

    # ... more instructions 
  ] 

  challenges = [  
    { step = "In your Google Cloud Console, navigate to the Cloud Run section.", command = "TBC" },
    { step = "Click on the 'Create Service' button to initiate the service creation process.", command = "TBC" },
    { step = "Specify \"${var.gcp_cr_2_name}\" as a unique name for your Cloud Run service.", command = "TBC" },
    { step = "Set up ingress settings as 'Allow all traffic'.", command = "TBC" },
    { step = "Review the service configuration and click 'Create' to deploy your Cloud Run service.", command = "TBC" },
    { step = "The task is now complete.", command = ""  },  

    # ... more challenges 
  ] 

}
