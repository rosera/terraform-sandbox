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
  default     = "Google Cloud Professional Database Engineer"
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
      "title" = "You need to export a large Cloud SQL for PostgreSQL instance. The databases in the instance are used heavily in production, and export time is not a concern. You want to conduct the export operation without affecting the performance of the database. What should you do?"
      "answer" = "Use serverless export."
      "members" = [
        "Use Datastream.",
        "Use serverless export.",
        "Use Database Migration Service.",
        "Use Cloud SQL in high availability (HA) mode.",
      ]
    },
    {
      "title" = "You migrated your on-premises MySQL instances to Cloud SQL on Google Cloud. The instances have been functioning as expected for the past six months. You need to optimize costs. What should you do?"
      "answer" = "Apply the recommendations from the Cloud SQL overprovisioned recommender."
      "members" = [
        "Review past logs in Cloud Logging to plan virtual machine (VM) resources.",
        "Apply the recommendations from the Cloud SQL overprovisioned recommender.",
        "Use Query Insights to identify query performance and plan VM resources accordingly.",
        "Review utilization on Cloud Monitoring dashboards to plan VM resources.",
      ]
    },
    {
      "title" = "You are part of the database maintenance team at your company. You are running a MySQL instance on a Compute Engine virtual machine (VM). The applications team raised a high-priority ticket regarding slow responses to queries running on the database. You need to quickly identify the slow queries. What should you do?"
      "answer" = "Set the database-flags options for slow_query_log. Then look for mysql-slow.log in the Logs Explorer."
      "members" = [
        "Add application logs before and after each of the queries.",
        "Configure your application to export spans to Cloud Trace.",
        "Migrate the MySQL instance to Cloud SQL, and then look at Query Insights.",
        "Set the database-flags options for slow_query_log. Then look for mysql-slow.log in the Logs Explorer.",
      ]
    },
    {
      "title" = "You are creating applications for your company in the retail industry. Orders are stored in Cloud Spanner, and your flagship store uses storeId “12345.” Management wants to regularly run a query on this store for different customers. You want to parameterize this query for performance. What should you do?"
      "answer" = "select productIds from orders where customerId=@customerId and storeId='12345'"
      "members" = [
        "select productIds from orders where customerId=@customerId and storeId='12345'",
        "select productIds from orders where customerId=@customerId and storeId=@storeId",
        "select productIds from orders where customerId like @customerId and storeId=@storeId",
        "select productIds from orders where customerId like @customerId and storeId='12345'",
      ]
    },
    {
      "title" = "Analysts in your company have raised concerns about performance and failed queries from the most recent Thursday to Monday. You look at the logs on Tuesday and discover nearly 50 \"deadlock detected\" errors. In the future, you want to take a more proactive approach to discovering database issues. What should you do?"
      "answer" = "Create a Cloud Monitoring metric with \"deadlock detected\" as the text payload, and set notifications based on it."
      "members" = [
        "Export the logs daily to BigQuery, and run a search for \"deadlock detected\" on the data.",
        "Create a Cloud Monitoring metric with \"deadlock detected\" as the text payload, and set notifications based on it.",
        "Create a Cloud Monitoring dashboard, and watch for any issues related to congestion that could indicate a deadlock.",
        "Write a Cloud Function to poll the database logs for \"deadlock detected\" errors, and schedule the Cloud Function to run every hour on Cloud Scheduler.",
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
