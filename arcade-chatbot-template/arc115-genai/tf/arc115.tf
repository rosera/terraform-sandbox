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
  default     = "Google Cloud Professional Data Engineer"
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
      "title" = "You are working on optimizing BigQuery for a query that is run repeatedly on a single table. The data queried is about 1 GB, and some rows are expected to change about 10 times every hour. You have optimized the SQL statements as much as possible. You want to further optimize the query's performance.  What should you do?"
      "answer" = "Create a materialized view based on the table, and query that view."
      "members" = [
        "Create a materialized view based on the table, and query that view.",
        "Enable caching of the queried data so that subsequent queries are faster.",
        "Create a scheduled query, and run it a few minutes before the report has to be created.",
        "Reserve a larger number of slots in advance so that you have maximum compute power to execute the query.",
      ]
    },
    {
      "title" = "Several years ago, you built a machine learning model for an ecommerce company. Your model made good predictions. Then a global pandemic occurred, lockdowns were imposed, and many people started working from home. Now the quality of your model has degraded. You want to improve the quality of your model and prevent future performance degradation. What should you do?"
      "answer" = "Retrain the model with data from the last 30 days. Add a step to continuously monitor model input data for changes, and retrain the model."
      "members" = [
        "Retrain the model with data from the first 30 days of the lockdown.",
        "Monitor data until usage patterns normalize, and then retrain the model.",
        "Retrain the model with data from the last 30 days. After one year, return to the older model.",
        "Retrain the model with data from the last 30 days. Add a step to continuously monitor model input data for changes, and retrain the model.",
      ]
    },
    {
      "title" = "A new member of your development team works remotely. The developer will write code locally on their laptop, which will connect to a MySQL instance on Cloud SQL. The instance has an external (public) IP address. You want to follow Google-recommended practices when you give access to Cloud SQL to the new team member. What should you do?"
      "answer" = "Give instance access permissions in Identity and Access Management (IAM), and have the developer run Cloud SQL Auth proxy to connect to a MySQL instance."
      "members" = [
        "Ask the developer for their laptop's IP address, and add it to the authorized networks list.",
        "Remove the external IP address, and replace it with an internal IP address. Add only the IP address for the remote developer's laptop to the authorized list.",
        "Give instance access permissions in Identity and Access Management (IAM), and have the developer run Cloud SQL Auth proxy to connect to a MySQL instance.",
        "Give instance access permissions in Identity and Access Management (IAM), change the access to \"private service access\" for security, and allow the developer to access Cloud SQL from their laptop.",
      ]
    },
    {
      "title" = "Your Cloud Spanner database stores customer address information that is frequently accessed by the marketing team. When a customer enters the country and the state where they live, this information is stored in different tables connected by a foreign key. The current architecture has performance issues. You want to follow Google-recommended practices to improve performance. What should you do?"
      "answer" = "Create interleaved tables, and store states under the countries."
      "members" = [
        "Create interleaved tables, and store states under the countries.",
        "Denormalize the data, and have a row for each state with its corresponding country.",
        "Retain the existing architecture, but use short, two-letter codes for the countries and states.",
        "Combine the countries in a single cell's text, for example \"country:state1,state2, …\" and when required, split the data.",
      ]
    },
    {
      "title" = "Your company runs its business-critical system on PostgreSQL. The system is accessed simultaneously from many locations around the world and supports millions of customers. Your database administration team manages the redundancy and scaling manually. You want to migrate the database to Google Cloud. You need a solution that will provide global scale and availability and require minimal maintenance. What should you do?"
      "answer" = "Migrate to Cloud Spanner."
      "members" = [
        "Migrate to BigQuery.",
        "Migrate to Cloud Spanner.",
        "Migrate to a Cloud SQL for PostgreSQL instance.",
        "Migrate to bare metal machines with PostgreSQL installed.",
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
