# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Cloud Firestore
#-----------------------------------------------------------------------------
variable "gcp_firestore_ref_1" {
  type        = string
  description = "Task Reference"
  default     = "fs-1"
}

variable "gcp_firebase_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/firebase.png"
}

variable "gcp_firestore_db_name" {
  type        = string
  description = "Firestore database name"
  default     = "sports"
}

variable "gcp_firestore_db_collection_name" {
  type    = string
  default = "premiership"
}

# Variables: Firestore 
#-----------------------------------------------------------------------------
module "firestore_db_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # IAM: Bind Storage Admin 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = var.gcp_firestore_ref_1
  title      = "Create a Firestore database"  
  image      = var.gcp_icon  
  resource_name = "${var.gcp_firestore_db_name}" 

  instructions = [
    { "step": "Go to the Google Cloud Console. You can find this by searching for 'Google Cloud Console' in your browser or going directly to console.cloud.google.com.", "command": "" },
    { "step": "Select the project where you want to create the Cloud Firestore database. The project selection dropdown is usually located at the top of the console. If you don't have a project, you'll need to create one first.", "command": "" },
    { "step": "Navigate to the Firestore section. You can find this by searching for 'Firestore' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Databases' then 'Firestore'.", "command": "" },
    { "step": "Click the 'Create database' button.", "command": "" },
    { "step": "Choose \"${var.gcp_region}\" as the location for your database.", "command": "" },
    { "step": "Choose the 'Start in test mode' option. Production is generally recommended for applications that are ready to be deployed.  If you are just experimenting or testing, you may choose 'Start in test mode' instead. Be aware that test mode has limitations on data retention and billing.", "command": "" },
    { "step": "Click 'Create database'.  This will provision your new Cloud Firestore database.", "command": "" },
    { step = "The task is now complete.", command = ""  },  
  ]

  challenges = [  
    { "step": "Navigate to the Firestore section. You can find this by searching for 'Firestore' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Databases' then 'Firestore'.", "command": "" },
    { "step": "Click the 'Create database' button.", "command": "" },
    { "step": "Choose \"${var.gcp_region}\" as the location for your database.", "command": "" },
    { "step": "Choose the 'Start in test mode' option. Production is generally recommended for applications that are ready to be deployed.  If you are just experimenting or testing, you may choose 'Start in test mode' instead. Be aware that test mode has limitations on data retention and billing.", "command": "" },
    # ... more challenges 
  ] 

}


# Variables: Cloud Firestore
#-----------------------------------------------------------------------------
variable "gcp_firestore_ref_2" {
  type        = string
  description = "Task Reference"
  default     = "fs-2"
}


# Variables: Firestore 
#-----------------------------------------------------------------------------
module "firestore_db_collection" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # IAM: Bind Storage Admin 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = var.gcp_firestore_ref_2
  title      = "Create a Firestore collection"  
  image      = var.gcp_icon  
  resource_name = "${var.gcp_firestore_db_name}" 

  instructions = [
    { "step": "Go to the Google Cloud Console. You can find this by searching for 'Google Cloud Console' in your browser or going directly to console.cloud.google.com.", "command": "" },
    { "step": "Select the project where your Cloud Firestore database exists. The project selection dropdown is usually located at the top of the console.", "command": "" },
    { "step": "Navigate to the Firestore section. You can find this by searching for 'Firestore' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Databases' then 'Firestore'.", "command": "" },
    { "step": "Select the 'sports' database. You should see a list of your Firestore databases; click on 'sports' to open its data browser.", "command": "" },
    { "step": "Click the '+ Start collection' button. This is typically found in the data browser view for your selected database. If you already have collections, you might see a 'Start collection' button or an option to add a new collection.", "command": "" },
    { "step": "In the 'Collection ID' field, enter \"${var.gcp_firestore_db_collection_name}\". This is the name of your new collection.", "command": "" },
    { "step": "(Optional) Add an initial document to the collection.  You can choose to create an empty collection initially and add documents later, or add a document right away. If you choose to add a document, you will be prompted for the Document ID and fields. You can choose to let Firestore generate the ID or specify one yourself.", "command": "" },
    { "step": "Click 'Save'. This will create the \"${var.gcp_firestore_db_collection_name}\" collection within your \"${var.gcp_firestore_db_name}\" Firestore database.", "command": "" },
    { step = "The task is now complete.", command = ""  },  
  ]

  challenges = [  
    { "step": "Navigate to the Firestore section. You can find this by searching for 'Firestore' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Databases' then 'Firestore'.", "command": "" },
    { "step": "Select the 'sports' database. You should see a list of your Firestore databases; click on 'sports' to open its data browser.", "command": "" },
    { "step": "Click the '+ Start collection' button. This is typically found in the data browser view for your selected database. If you already have collections, you might see a 'Start collection' button or an option to add a new collection.", "command": "" },
    { "step": "In the 'Collection ID' field, enter \"${var.gcp_firestore_db_collection_name}\". This is the name of your new collection.", "command": "" },
    { "step": "Click 'Save'. This will create the  \"${var.gcp_firestore_db_collection_name}\" collection within your  \"${var.gcp_firestore_db_name}\" Firestore database.", "command": "" },
    { step = "The task is now complete.", command = ""  },  
    # ... more challenges 
  ] 

}

