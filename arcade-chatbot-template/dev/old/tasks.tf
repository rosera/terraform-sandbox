# TASKS.tf
#-----------------------------------------------------------------------------
# 1. Locals - Generate a List of Questions
# 2. Module - Task definition to create a question
# 3. Resource - Generate JSON to be loaded into a Cloud Storage 

# Locals: Generate a List of Questions 
#-----------------------------------------------------------------------------
# Task: Assessment questions defined here 
locals {
  tasks = [
    module.task_one.question,
    module.task_two.question,
    # ... more tasks
  ]
}

# Module: Task definition to create a question 
#-----------------------------------------------------------------------------
module "task_one" {
  # TODO: Move source to terraform-lab-foundations
  # source = "./modules/chatbot_task"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"

  # ... Task Definition 
  tag         = "Task 1"
  question    = "Which subject area used in this lab?"
  options     = local.lab_list    # Random topic to discuss
  answer      = local.random_list # Assign question answer from list 
}

module "task_two" {
  # TODO: Move source to terraform-lab-foundations
  # source = "./modules/chatbot_task"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"

  # ... Task Definition 
  tag         = "Task 2"
  question    = "Which data item was referenced?"
  options     = local.lab_item[local.list_index]  # Example options
  answer      = local.random_item                 # Assign question answer from list 
}
