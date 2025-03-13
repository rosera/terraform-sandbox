#-----------------------------------------------------------------------------
# Arcade Wheel
# Description: Dynamic content for labs
# Ref: arcade_wheel.tf lab_list

# Locals: Tasks
#-----------------------------------------------------------------------------
# Task: Assessment questions defined here 
locals {
  tasks = [
    # Get the output object
    module.task_one.question,
    # ... Add more tasks
    module.task_two.question,
    # module.task_two.question,
  ]
}

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
