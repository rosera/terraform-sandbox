# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: BigQuery
#-----------------------------------------------------------------------------
variable "gcp_bq_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/bigquery.png"
}

variable "gcp_dataset_name" {
  type        = string
  description = "BQ Dataset name"
  default     = "sports"
}

variable "gcp_table_name" {
  type        = string
  description = "BQ Table name"
  default     = "premiership"
}

variable "gcp_view_name" {
  type        = string
  description = "BQ View name"
  default     = "relagation"
}



# Variables: BigQuery 
#-----------------------------------------------------------------------------
module "bq_dataset_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... BigQuery 
  # BigQuery: Create a Dataset 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = "bq-1"
  title      = "Create a BigQuery dataset"  
  image      = var.gcp_bq_icon  
  resource_name = "${var.gcp_dataset_name}" 

  challenges = [  
    { step = "Create a new BigQuery Dataset: \"${var.gcp_dataset_name}\".", command = "${var.gcp_dataset_name}"  }, 
    { step = "Set the dataset \"Location type\" as Region.", command = ""  },  
    { step = "Select \"${var.gcp_region}\" from the available list.", command = ""  },  
    # ... more challenges 
  ] 

  instructions = [  
    { step = "Open the Google BiqQuery console.", command = "" }, 
    { step = "Find the project labelled \"${var.gcp_project_id}.", command = "" },  
    { step = "Click the \"Action\" button (represented by three vertical dots).", command = ""  },  
    { step = "Click the \"Create dataset\" option.", command = ""  },  
    { step = "Enter the dataset name as \"${var.gcp_dataset_name}\".", command = "${var.gcp_dataset_name}"  },  
    { step = "Set the dataset \"Location type\" as Region.", command = ""  }, 
    { step = "Select \"${var.gcp_region}\" from the available list.", command = ""  }, 
    { step = "Click the \"CREATE DATASET\" button at the bottom of the screen.", command = ""  }, 
    { step = "The task is now complete.", command = ""  },  
    # ... more instructions 
  ] 
}

module "bq_table_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... BigQuery 
  # BigQuery: Create a Table 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = "bq-2"
  title      = "Create a BigQuery table"  
  image      = var.gcp_bq_icon  
  resource_name = "${var.gcp_dataset_name}" 

  challenges = [  
    { step = "Create a new Dataset Table: \"${var.gcp_dataset_name}\".", command = "${var.gcp_dataset_name}"  }, 
    { step = "Set the dataset \"Location type\" as Region.", command = ""  },  
    { step = "Select \"${var.gcp_region}\" from the available list.", command = ""  },  
    # ... more challenges 
  ] 

  instructions = [  
    { step = "Open the Google BiqQuery console.", command = "" }, 
    { step = "Find the project labelled \"${var.gcp_project_id}.", command = "" },  
    { step = "Click the \"Action\" button (represented by three vertical dots).", command = ""  },  
    { step = "Click the \"Create dataset\" option.", command = ""  },  
    { step = "Enter the dataset name as \"${var.gcp_dataset_name}\".", command = "${var.gcp_dataset_name}"  },  
    { step = "Set the dataset \"Location type\" as Region.", command = ""  }, 
    { step = "Select \"${var.gcp_region}\" from the available list.", command = ""  }, 
    { step = "Click the \"CREATE DATASET\" button at the bottom of the screen.", command = ""  }, 
    { step = "The task is now complete.", command = ""  },  
    # ... more instructions 
  ] 
}

module "bq_view_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... BigQuery 
  # BigQuery: Create a Dataset 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref        = "bq-3"
  title      = "Create a BigQuery View"  
  image      = var.gcp_bq_icon  
  resource_name = "${var.gcp_dataset_name}" 

  challenges = [  
    { step = "Create a new BigQuery View: \"${var.gcp_dataset_name}\".", command = "${var.gcp_dataset_name}"  }, 
    { step = "Set the dataset \"Location type\" as Region.", command = ""  },  
    { step = "Select \"${var.gcp_region}\" from the available list.", command = ""  },  
    # ... more challenges 
  ] 

  instructions = [  
    { step = "Open the Google BiqQuery console.", command = "" }, 
    { step = "Find the project labelled \"${var.gcp_project_id}.", command = "" },  
    { step = "Click the \"Action\" button (represented by three vertical dots).", command = ""  },  
    { step = "Click the \"Create dataset\" option.", command = ""  },  
    { step = "Enter the dataset name as \"${var.gcp_dataset_name}\".", command = "${var.gcp_dataset_name}"  },  
    { step = "Set the dataset \"Location type\" as Region.", command = ""  }, 
    { step = "Select \"${var.gcp_region}\" from the available list.", command = ""  }, 
    { step = "Click the \"CREATE DATASET\" button at the bottom of the screen.", command = ""  }, 
    { step = "The task is now complete.", command = ""  },  
    # ... more instructions 
  ] 
}
