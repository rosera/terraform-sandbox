# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Bill", "Mary" ]
}

## Lab Data List
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Google Cloud Associate Cloud Engineer"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Google Cloud exam revision knowledge agent"
}


## lab_list: Questions to be shown in the lab
## Type: There are four options presented
## title: String representing the title of the List e.g. "History, Geography, Artists"
## answer: String representing the question answer
## members: List of Strings, separate each item with a comma e.g. "Paris", "Napoleon"

## Constraint: Members == 4

variable "lab_list" {
  type = list(object({
    title = string
    answer = string
    members = list(string)
  }))

  default = [
    {
      "title" = "Your organization plans to migrate its financial transaction monitoring application to Google Cloud.
      "answer" = "Create a group for auditors, and assign roles/bigquery.dataViewer to them."
      "members" = [
        "Assign roles/bigquery.dataViewer to the individual auditors.",
        "Create a group for auditors and assign roles/viewer to them.",
        "Create a group for auditors, and assign roles/bigquery.dataViewer to them.",
        "Assign a custom role to each auditor that allows view-only access to BigQuery.",
      ]
    },
    {
      "title" = "You are managing your company’s first Google Cloud project. Project leads, developers, and internal
      "answer" = "Create groups. Assign an IAM Predefined role to each group as required, including those who should
      "members" = [
        "Assign a basic role to each user.",
        "Create groups. Assign a basic role to each group, and then assign users to groups.",
        "Create groups. Assign a Custom role to each group, including those who should have access to sensitive data.
        "Create groups. Assign an IAM Predefined role to each group as required, including those who should have acce
      ]
#    },
#    {
#      "title" = "One of EHR\\’s healthcare customers is an internationally renowned research and hospital facility.
#      "answer" = "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application o
#      "members" = [
#        "Deploy an external HTTP(S) load balancer, configure VPC firewall rules, and move the applications onto Comp
#        "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compu
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create a GKE service to expos
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create an internal load balan
#      ]
#    },
#    {
#      "title" = "The EHR sales employees are a remote-based workforce that travels to different locations to do thei
#      "answer" = "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application o
#      "members" = [
#        "Deploy an external HTTP(S) load balancer, configure VPC firewall rules, and move the applications onto Comp
#        "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compu
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create a GKE service to expos
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create an internal load balan
#      ]
#    },
#    {
#      "title" = "You are the data compliance officer for Mountkirk Games and must protect customers\\' personally id
#      "answer" = "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application o
#      "members" = [
#        "Deploy an external HTTP(S) load balancer, configure VPC firewall rules, and move the applications onto Compute Engine virtual machines.",
#        "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compute Engine virtual machines.",
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create a GKE service to expose the pods within the cluster, and set up a GKE network policy.",
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create an internal load balancer to expose the pods outside the cluster, and configure Identity-Aware Proxy (IAP) for access.",
#      ]
    }
  ]
}


## Task information 
## tasks: JSON format used by the lab 
variable tasks {
  type = list(object({
    tag      = string
    question = string
    option_a = string
    option_b = string
    option_c = string
    option_d = string
  }))
  
  default = [
    {
      tag      = "Add a Task and number"
      question = "Add a question"
      option_a = "Add an option"
      option_b = "Add an option"
      option_c = "Add an option"
      option_d = "Add an option"
    }
  ]
}
