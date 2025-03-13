#-----------------------------------------------------------------------------
# Arcade Wheel
# Description: Dynamic content for labs
# Ref: arcade_wheel.tf lab_list

# Locals: Personas
#-----------------------------------------------------------------------------
# Task: Personas defined here 
locals {
  personas = [
    # Get the output object
    module.persona_one.persona,
    # ... Add more personas 
    module.persona_two.persona,
    # module.persona_three.persona,
  ]
}

