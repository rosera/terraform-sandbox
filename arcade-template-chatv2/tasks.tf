
#-----------------------------------------------------------------------------
# Arcade Wheel
# Description: Dynamic content for labs
# Ref: variables.tf lab_list

# Variables: Chatbot Tasks 
#-----------------------------------------------------------------------------

## Define a random number to index the list
## Constraint - uses zero to list length
resource random_integer "list_index" {
  min = 0
  max = length(var.lab_list) -1
}

## Define a random number to index the list items
## Constraint - item list, then uses zero to members list length
resource random_integer "item_index" {
  min = 0
  max = length(var.lab_list[local.list_index].members ) -1
}

# Random: List definitions created here 
locals {
  ## Define a Lab topic
  lab_topic   = var.lab_topic
  lab_persona = var.lab_persona
  lab_context = var.lab_context 

  ## Define random index
  list_index   = random_integer.list_index.result
  member_index = random_integer.item_index.result

  ## Define List Members
  lab_list = [for item in var.lab_list : item.title]
  lab_item = [for item in var.lab_list : item.members]

  ## Define Random selection 
  random_list = local.lab_list[local.list_index]
  random_item = local.lab_item[local.list_index][local.member_index]
}

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
  answer      = local.random_list                 # Assign question answer from list 
}
