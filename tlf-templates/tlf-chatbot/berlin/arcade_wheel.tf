#-----------------------------------------------------------------------------
# Arcade Wheel
# Description: Dynamic content for labs
# Ref: variables.tf lab_list
# Tasks: tasks.tf
# Personas: personas.tf
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
  lab_persona = var.lab_persona[0]
  lab_context = var.lab_context 

  ## Define random index
  list_index   = random_integer.list_index.result
  member_index = random_integer.item_index.result

  ## Define List Members
  lab_list   = [for item in var.lab_list : item.title]
  lab_item   = [for item in var.lab_list : item.members]
  lab_answer = [for item in var.lab_list : item.answer]

  ## Define Random selection 
  random_list = local.lab_list[local.list_index]
  random_item = local.lab_item[local.list_index][local.member_index]
}
