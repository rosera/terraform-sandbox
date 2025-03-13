# Module: Tasks Questions
#-----------------------------------------------------------------------------
module "task_one" {
  # TODO: Move source to terraform-lab-foundations
  # source = "./modules/chatbot_task"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"

  # ... Task Definition 
  tag         = "Task 1"
  question    = local.lab_list[local.list_index]    # Question 
  options     = local.lab_item[local.list_index]    # Example options
  answer      = local.lab_answer[local.list_index]  # Assign question answer from list 
}

## module "task_two" {
##   # TODO: Move source to terraform-lab-foundations
##   # source = "./modules/chatbot_task"
##   source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"
## 
##   # ... Task Definition 
##   tag         = "Task 2"
##   question    = "Which data item was referenced?"
##   options     = local.lab_item[local.list_index]  # Example options
##   answer      = local.random_item                 # Assign question answer from list 
## }
## 
## module "task_three" {
##   # TODO: Move source to terraform-lab-foundations
##   # source = "./modules/chatbot_task"
##   source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"
## 
##   # ... Task Definition 
##   tag         = "Task 3"
##   question    = "Which data item was referenced?"
##   options     = local.lab_item[local.list_index]  # Example options
##   answer      = local.random_item                 # Assign question answer from list 
## }
## 
## module "task_four" {
##   # TODO: Move source to terraform-lab-foundations
##   # source = "./modules/chatbot_task"
##   source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"
## 
##   # ... Task Definition 
##   tag         = "Task 4"
##   question    = "Which data item was referenced?"
##   options     = local.lab_item[local.list_index]  # Example options
##   answer      = local.random_item                 # Assign question answer from list 
## }
## 
## module "task_five" {
##   # TODO: Move source to terraform-lab-foundations
##   # source = "./modules/chatbot_task"
##   source = "github.com/CloudVLab/terraform-lab-foundation//solutions/chatbot_questions/stable"
## 
##   # ... Task Definition 
##   tag         = "Task 5"
##   question    = "Which data item was referenced?"
##   options     = local.lab_item[local.list_index]  # Example options
##   answer      = local.random_item                 # Assign question answer from list 
## }
