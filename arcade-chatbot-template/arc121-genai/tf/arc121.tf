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
      "title" = "Your organization plans to migrate its financial transaction monitoring application to Google Cloud. Auditors need to view the data and run reports in BigQuery, but they are not allowed to perform transactions in the application. You are leading the migration and want the simplest solution that will require the least amount of maintenance. What should you do?"
      "answer" = "Create a group for auditors, and assign roles/bigquery.dataViewer to them."
      "members" = [
        "Assign roles/bigquery.dataViewer to the individual auditors.",
        "Create a group for auditors and assign roles/viewer to them.",
        "Create a group for auditors, and assign roles/bigquery.dataViewer to them.",
        "Assign a custom role to each auditor that allows view-only access to BigQuery.",
      ]
    },
    {
      "title" = "You are managing your company’s first Google Cloud project. Project leads, developers, and internal testers will participate in the project, which includes sensitive information. You need to ensure that only specific members of the development team have access to sensitive information. You want to assign the appropriate Identity and Access Management (IAM) roles that also require the least amount of maintenance. What should you do?"
      "answer" = "Create groups. Assign an IAM Predefined role to each group as required, including those who should have access to sensitive data. Assign users to groups."
      "members" = [
        "Assign a basic role to each user.",
        "Create groups. Assign a basic role to each group, and then assign users to groups.",
        "Create groups. Assign a Custom role to each group, including those who should have access to sensitive data. Assign users to groups.",
        "Create groups. Assign an IAM Predefined role to each group as required, including those who should have access to sensitive data. Assign users to groups.",
      ]
    },
    {
      "title" = "You are responsible for monitoring all changes in your Cloud Storage and Firestore instances. For each change, you need to invoke an action that will verify the compliance of the change in near real time. You want to accomplish this with minimal setup. What should you do?"
      "answer" = "Use Cloud Function events, and call the security script from the Cloud Function triggers."
      "members" = [
        "Use the trigger mechanism in each datastore to invoke the security script.",
        "Use Cloud Function events, and call the security script from the Cloud Function triggers.",
        "Use a Python script to get logs of the datastores, analyze them, and invoke the security script.",
        "Redirect your data-changing queries to an App Engine application, and call the security script from the application.",
      ]
    },
    {
      "title" = "Your application needs to process a significant rate of transactions. The rate of transactions exceeds the processing capabilities of a single virtual machine (VM). You want to spread transactions across multiple servers in real time and in the most cost-effective manner. What should you do?"
      "answer" = "Send transactions to Pub/Sub. Process them in VMs in a managed instance group."
      "members" = [
        "Send transactions to BigQuery. On the VMs, poll for transactions that do not have the ‘processed’ key, and mark them ‘processed’ when done.",
        "Set up Cloud SQL with a memory cache for speed. On your multiple servers, poll for transactions that do not have the ‘processed’ key, and mark them ‘processed’ when done.",
        "Send transactions to Pub/Sub. Process them in VMs in a managed instance group.",
        "Record transactions in Cloud Bigtable, and poll for new transactions from the VMs.",
      ]
    },
    {
      "title" = "Your team needs to directly connect your on-premises resources to several virtual machines inside a virtual private cloud (VPC). You want to provide your team with fast and secure access to the VMs with minimal maintenance and cost. What should you do?"
      "answer" = "Use Cloud VPN to create a bridge between the VPC and your network."
      "members" = [
        "Set up Cloud Interconnect.",
        "Use Cloud VPN to create a bridge between the VPC and your network.",
        "Assign a public IP address to each VM, and assign a strong password to each one.",
        "Start a Compute Engine VM, install a software router, and create a direct tunnel to each VM.",
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
