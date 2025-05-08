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
    },
    {
      "title" = "You work at an enterprise company that wants to enforce central management of all Google Cloud firewall rules. Currently, each internal business unit uses folders to manage their Google Cloud projects and network. You want the ability to deny incoming requests to the business unit's Compute Engine VMs. What should you do?"
      "answer" = "Create a hierarchical firewall policy at the organization level, and deny all ingress traffic to the required business unit."
      "members" = [
        "Configure VPC firewall rules to deny and allow traffic.",
        "Create a Shared VPC network, and configure the firewall in the host project.",
        "Create a hierarchical firewall policy at the organization level, and allow all egress traffic to the required business unit.",
        "Create a hierarchical firewall policy at the organization level, and deny all ingress traffic to the required business unit.",
      ]
    },
    {
      "title" = "Your customer has SaaS applications on Google Cloud. You want your services to be available to the customers' application in the most secure and cost-effective way. What should you do?"
      "answer" = "Configure VPC Network Peering to connect directly into their Google Cloud VPC network."
      "members" = [
        "Configure a Cloud VPN gateway that provides a connection into their Google Cloud VPC network.",
        "Create a Cloud Identity account to give you access into their Google Cloud VPC network.",
        "Configure VPC Network Peering to connect directly into their Google Cloud VPC network.",
        "Create a custom HTTP application that provides a connection to their Google Cloud VPC network.",
      ]
    },
    {
      "title" = "You need to create a Google Kubernetes Engine (GKE) cluster that prevents inbound external access. You want the cluster to allow certain nodes to have outbound internet access. What should you do?"
      "answer" = "Create a private GKE cluster, and use Cloud NAT for external access."
      "members" = [
        "Create a VPC-native cluster, and enable private nodes.",
        "Create a private GKE cluster, and enable private nodes.",
        "Create a private GKE cluster, and use Cloud NAT for external access.",
        "Create a GKE cluster within a Shared VPC network, and create a firewall rule that allows external access for the node.",
      ]
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
