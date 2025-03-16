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
  default     = "Google Cloud Professional Security Engineer"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Google Cloud exam revision"
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
      "title" = "Developers in an organization are prototyping a few applications on Google Cloud and are starting to store sensitive information on Google Cloud. The developers are using their personal/consumer Gmail accounts to set up and manage their projects within Google Cloud. A security engineer identifies this practice as a concern to the leadership team because of the lack of centralized project management and access to the data being stored in these accounts. Which solution should be used to resolve this concern?"
      "answer" = "Set up Cloud Identity and require the developers to use those accounts for Google Cloud work."
      "members" = [
        "Enforce the setup of Security Keys as the 2-Step Verification method for those Gmail accounts.",
        "Set up Cloud Identity and require the developers to use those accounts for Google Cloud work.",
        "Require the developers to log/store their Gmail passwords with the security team.",
        "Enable logging on all Google Cloud projects to track all developer activities.",
      ]
    },
    {
      "title" = "A customer wants to use Cloud Identity as their primary IdP. The customer wants to use other non-Google Cloud SaaS products for CRM, messaging, and customer ticketing management. The customer also wants to improve employee experience with Single Sign-On (SSO) capabilities to securely access Google Cloud and non-Google Cloud applications. Only authorized individuals should be able to access these third-party applications. What action should the customer take to meet these requirements?"
      "answer" = "Copy user personas from Cloud Identity to all third-party applications for the domain."
      "members" = [
        "Remove the employee from Cloud Identity, set the correct license for the individuals, and resync them to Cloud Identity for the changes to take effect.",
        "Configure third-party applications to federate authentication and authorization to the Google Cloud IdP.",
        "Remove the individuals from the third-party applications, add the license to Cloud Identity, and resync the individuals back to the third-party applications.",
        "Copy user personas from Cloud Identity to all third-party applications for the domain.",
      ]
#    },
#    {
#      "title" = "One of EHR\\’s healthcare customers is an internationally renowned research and hospital facility. Many of their patients are well-known public personalities. Sources both inside and outside have tried many times to obtain health information on these patients for malicious purposes. The hospital requires that patient information stored in Cloud Storage buckets not leave the geographic areas in which the buckets are hosted. You need to ensure that information stored in Cloud Storage buckets in the \"europe-west2\" region does not leave that area. What should you do?"
#      "answer" = "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compute Engine virtual machines."
#      "members" = [
#        "Deploy an external HTTP(S) load balancer, configure VPC firewall rules, and move the applications onto Compute Engine virtual machines.",
#        "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compute Engine virtual machines.",
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create a GKE service to expose the pods within the cluster, and set up a GKE network policy.",
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create an internal load balancer to expose the pods outside the cluster, and configure Identity-Aware Proxy (IAP) for access.",
#      ]
#    },
#    {
#      "title" = "The EHR sales employees are a remote-based workforce that travels to different locations to do their jobs. Regardless of their location, the sales employees need to access web-based sales tools located in the EHR data center. EHR is retiring their current Virtual Private Network (VPN) infrastructure, and you need to move the web-based sales tools to a BeyondCorp access model. Each sales employee has a Google Workspace account and uses that account for single sign-on (SSO). What should you do?"
#      "answer" = "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compute Engine virtual machines."
#      "members" = [
#        "Deploy an external HTTP(S) load balancer, configure VPC firewall rules, and move the applications onto Compute Engine virtual machines.",
#        "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compute Engine virtual machines.",
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create a GKE service to expose the pods within the cluster, and set up a GKE network policy.",
#        "Containerize the application and move it into Google Kubernetes Engine (GKE). Create an internal load balancer to expose the pods outside the cluster, and configure Identity-Aware Proxy (IAP) for access.",
#      ]
#    },
#    {
#      "title" = "You are the data compliance officer for Mountkirk Games and must protect customers\\' personally identifiable information (PII). Mountkirk Games wants to make sure they can generate anonymized usage reports about their new game and delete PII data after a specific period of time. The solution should have minimal cost. You need to ensure compliance while meeting business and technical requirements. What should you do?"
#      "answer" = "Deploy an external HTTP(S) load balancer, configure Google Cloud Armor, and move the application onto Compute Engine virtual machines."
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
