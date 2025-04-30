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
