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
  default     = "Google Cloud Professional Network Engineer"
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
      "title" = "You have a global secure web application hosted on a Compute Engine unmanaged instance group. The application is currently deployed in us￾central1-a. However, due to company growth, most of your new customers are geographically closer to the europe-west2 region. You need to implement a solution that allows the application to automatically scale to meet the demand for future customers and also follows Google-recommended practices. What should you do?"
      "answer" = "Deploy an HTTP(S) load balancer with a global virtual IP address. Configure a backend in europe-west2-a with a managed instance group."
      "members" = [
        "Deploy a network load balancer with a regional virtual IP address. Configure a backend with a managed instance group.",
        "Deploy an HTTP(S) load balancer with a regional virtual IP address. Configure a backend with a managed instance group.",
        "Deploy an HTTP(S) load balancer with a global virtual IP address. Configure a backend in europe-west2-a with a managed instance group.",
        "Deploy a network load balancer with a global virtual IP address. Configure a backend in europe-west2-a with an unmanaged instance group.",
      ]
    },
    {
      "title" = "Your company has a regional Compute Engine software as a service (SaaS) application that currently allows traffic from the entire internet. The application should not be accessible from the public internet. You also want to allow only certain virtual machines (VMs) to access your application by using Secure Shell (SSH). What should you do to satisfy the requirements?"
      "answer" = "Delete the prepopulated rule that allows SSH traffic from 0.0.0.0/0. Create a network tag that allows access to TCP 22, and apply the tag to each VM that will access the application."
      "members" = [
        "Delete the rule that allows traffic from 0.0.0.0/0. Create a firewall rule to allow traffic from 192.168.0.0/16, 172.16.0.0/12, and 10.0.0.0/8.",
        "Create a new rule that denies traffic from 0.0.0.0/0. Create a firewall rule to deny traffic from 192.168.0.0/16, 172.16.0.0/12, and 10.0.0.0/8.",
        "Delete the prepopulated rule that allows SSH traffic from 0.0.0.0/0. Create a network tag that allows access to TCP 22, and apply the tag to each VM that will access the application.",
        "Delete the prepopulated rule that allows SSH traffic from 0.0.0.0/0. Create a network tag that allows access to TCP 3389, and apply the newly created tag to each VM that will access the application.",
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
