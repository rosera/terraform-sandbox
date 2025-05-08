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
  default     = "Google Cloud Digital Leader"
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
      "title" = "How can Google Cloud help an organization achieve its sustainability goals?"
      "answer" = "Google Cloud data centers are ISO certified for their environmental performance and efficiency."
      "members" = [
        "Google Cloud data centers are carbon free.",
        "Data centers have maximum physical security.",
        "Data centers are regionally distributed around the world.",
        "Google Cloud data centers are ISO certified for their environmental performance and efficiency.",
      ]
    },
    {
      "title" = "An organization is monitoring a service level indicator based on the volume of traffic that their application is receiving. Why is it important to monitor this indicator?"
      "answer" = "Historical trends in traffic can be used for capacity planning."
      "members" = [
        "The volume of traffic always affects the user experience.",
        "High traffic levels are frequently tied to degrading performance.",
        "Historical trends in traffic can be used for capacity planning.",
        "Low traffic volumes always indicate configuration issues.",
      ]
    },
    {
      "title" = "An organization has raised a support case with Google Cloud Customer Care. When is it appropriate for a case to be escalated?"
      "answer" = "When flagging a break in the process or a communication issue"
      "members" = [
        "When a high-impact issue needs to be resolved as fast as possible",
        "When the priority of the ticket has been set incorrectly",
        "When flagging a break in the process or a communication issue",
        "When a case has been resolved and needs to be reopened",
      ]
    },
    {
      "title" = "An organization wants to track and understand its expenses on Google Cloud and receive recommendations on cost optimizations. Which tool should the organization use?"
      "answer" = "Cloud Billing reports"
      "members" = [
        "Cloud Billing reports",
        "Resource quotas and thresholds",
        "Committed use discounts",
        "Invoices",
      ]
    },
    {
      "title" = "An organization wants to analyze data collected from a fleet of rental vehicles. Onboard sensors send location data every 30 seconds. They want to ingest this data. Which Google product or service should they use?"
      "answer" = "Pub/Sub"
      "members" = [
        "Dataflow",
        "Pub/Sub",
        "Cloud SQL",
        "Cloud Storage",
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
