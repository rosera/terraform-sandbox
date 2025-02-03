# Arcade Hero 
# Description: Dynamic content for labs
#-----------------------------------------------------------------------------

# Variables: Google Cloud Storage 
#-----------------------------------------------------------------------------
variable "gcp_pubsub_icon" {
  type        = string
  description = "key file location"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/pubsub.png"
}

variable "gcp_topic_name" {
  type        = string
  description = "PubSub Topic name"
  default     = "sports_topic"
}

variable "gcp_subscription_name" {
  type        = string
  description = "PubSub Subscription name"
  default     = "sports_subscription"
}

# Variables: Cloud PubSub 
#-----------------------------------------------------------------------------
module "pubsub_topic_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Google Cloud PubSub 
  # Google Cloud PubSub: Create a Topic 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "pubsub-1"
  title         = "Create a PubSub Topic"
  image         = "https://storage.googleapis.com/spls/arc-hero/assets/images/pubsub.png"
  resource_name = "${var.gcp_project_id}-${var.gcp_bucket_name}"

  instructions = [
  
    { step = "Go to the Google Cloud Console. You can find this by searching for 'Google Cloud Console' in your browser or going directly to console.cloud.google.com.", "command": "" },
    { step = "Select the project \"${var.gcp_project_id}\" where you want to create the Pub/Sub topic. The project selection dropdown is usually located at the top of the console. If you don't have a project, you'll need to create one first.", "command": "" },
    { step = "Navigate to the Pub/Sub section. You can find this by searching for 'Pub/Sub' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Networking' then 'Pub/Sub'.", "command": "" },
    { step = "Click on 'Topics' in the left-hand navigation menu.", "command": "" },
    { step = "Click the 'CREATE TOPIC' button.", "command": "" },
    { step = "In the 'Topic ID' field, enter \"${var.gcp_topic_name}\". This is the name of your new topic.", "command": "" },
    { step = "(Optional) Configure other topic settings such as message retention duration, KMS encryption, or schema settings if needed. For a basic topic, you can often leave these at their defaults.", "command": "" },
    { step = "Click 'CREATE'. This will create the \"${var.gcp_topic_name}\" Pub/Sub topic in your selected project.", "command": "" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]

  challenges = [
    { step = "Select the project \"${var.gcp_project_id}\" where you want to create the Pub/Sub topic. The project selection dropdown is usually located at the top of the console. If you don't have a project, you'll need to create one first.", "command": "" },
    { step = "Navigate to the Pub/Sub section. You can find this by searching for 'Pub/Sub' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Networking' then 'Pub/Sub'.", "command": "" },
    { step = "In the 'Topic ID' field, enter \"${var.gcp_topic_name}\". This is the name of your new topic.", "command": "" },
    { step = "Click 'CREATE'. This will create the \"${var.gcp_topic_name}\" Pub/Sub topic in your selected project.", "command": "" },
    # ... more challenges
  ]

}


# Variables: Cloud PubSub
#-----------------------------------------------------------------------------
module "pubsub_subscription_create" {
  # TODO: Move source to terraform-lab-foundations
  source = "./modules/arcade_task"

  # ... Google Cloud PubSub 
  # PubSub: Create a Subscription 
  project_id = var.gcp_project_id
  region     = var.gcp_region
  zone       = var.gcp_zone

  ref           = "pubsub-2"
  title         = "Create a PubSub Subscription"
  image         = "https://storage.googleapis.com/spls/arc-hero/assets/images/pubsub.png"
  resource_name = "${var.gcp_project_id}-${var.gcp_bucket_name}"

  instructions = [
  
    { step = "Go to the Google Cloud Console. You can find this by searching for 'Google Cloud Console' in your browser or going directly to console.cloud.google.com.", "command": "" },
    { step = "Select the project \"${var.gcp_project_id}\" where you want to create the Pub/Sub topic. The project selection dropdown is usually located at the top of the console. If you don't have a project, you'll need to create one first.", "command": "" },
    { step = "Navigate to the Pub/Sub section. You can find this by searching for 'Pub/Sub' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Networking' then 'Pub/Sub'.", "command": "" },
    { step = "Click on 'Subscriptions' in the left-hand navigation menu.", "command": "" },
    { step = "Click the 'CREATE SUBSCRIPTION' button.", "command": "" },
    { step = "In the 'Subscription ID' field, enter \"${var.gcp_subscription_name}\" as the name of your new subscription. This should be unique within your project.", "command": "" },
    { step = "In the 'Topic ID' field, enter \"${var.gcp_topic_name}\".", "command": "" },
    { step = "(Optional) Configure other subscription settings such as message acknowledgement deadline, message retention, dead-letter queues, or push delivery if needed. For a basic subscription, you can often leave these at their defaults.", "command": "" },
    { step = "Click 'CREATE'. This will create the subscription to 'sports_topic' in your selected project.", "command": "" },
    { step = "The task is now complete.", command = "" },
    # ... more instructions
  ]

  challenges = [
    { step = "Select the project \"${var.gcp_project_id}\" where you want to create the Pub/Sub topic. The project selection dropdown is usually located at the top of the console. If you don't have a project, you'll need to create one first.", "command": "" },
    { step = "Navigate to the Pub/Sub section. You can find this by searching for 'Pub/Sub' in the console's search bar, or by navigating through the menu (usually represented by three horizontal lines) and finding 'Networking' then 'Pub/Sub'.", "command": "" },
    { step = "In the 'Subscription ID' field, enter \"${var.gcp_subscription_name}\" as the name of your new subscription. This should be unique within your project.", "command": "" },
    { step = "In the 'Topic ID' field, enter \"${var.gcp_topic_name}\".", "command": "" },
    { step = "Click 'CREATE'. This will create the subscription to 'sports_topic' in your selected project.", "command": "" },
    { step = "The task is now complete.", command = "" },
    # ... more challenges
  ]

}
