# Module: Tasks Questions
#-----------------------------------------------------------------------------
# Update: variables.tf with lab_list variable
module "task_one" {
  # TODO: Move source to terraform-lab-foundations
  # source = "./modules/chatbot_task"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"

  # ... Task Definition 
  tag         = "Task 1"
  question    = local.lab_list[0]    # Question 
  options     = local.lab_item[0]    # Example options
  answer      = local.lab_answer[0]  # Assign question answer from list 
}

# Update: variables.tf with lab_list variable
module "task_two" {
  # TODO: Move source to terraform-lab-foundations
  # source = "./modules/chatbot_task"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"

  # ... Task Definition 
  tag         = "Task 2"
  question    = local.lab_list[1]    # Question 
  options     = local.lab_item[1]    # Example options
  answer      = local.lab_answer[1]  # Assign question answer from list 
}


#-----------------------------------------------------------------------------
# Create a bucket object containing a dynamically generated question

resource "google_storage_bucket_object" "task_object" {
  name   = "tasks.json"
  bucket = module.la_gcs.gcs_bucket_name

  ## Encode a question in JSON format
  content = jsonencode({
    "tasks": [
      # for task in var.tasks : {
      for task in local.tasks : {
        tag       = task.tag
        question  = task.question
        option_a  = task.options[0]
        option_b  = task.options[1]
        option_c  = task.options[2]
        option_d  = task.options[3]
        answer    = task.answer
      }
    ],
    "author": "Rich Rose",
    "publish": "18th Aug 2024"
    "uri": "${var.gcp_region}-${var.gcp_project_id}.cloudfunctions.net"
    "endpoint": "/arcade-1"
  })
}


