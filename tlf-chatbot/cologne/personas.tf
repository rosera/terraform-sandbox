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

# Module: Persona 
#-----------------------------------------------------------------------------
module "persona_one" {
  # TODO: Move source to terraform-lab-foundations
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/set_persona/stable"

  # ... Persona Definition
  name        = var.lab_persona[0]
  topic       = var.lab_topic 
  knowledge   = "Uefa Euro 2024 and the location ${var.lab_topic}" 
  role        = "I am a  ${var.lab_context}" 
  messageText = "I can help you during your visit to ${var.lab_topic} and the Uefa Euros 2024"
  imageUrl    = "https://storage.googleapis.com/spls/arc-images/euro2024/hans.png"
  time        = "29 May"
  endpoint    = "/v1/v1"
}

module "persona_two" {
  # TODO: Move source to terraform-lab-foundations
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/set_persona/stable"

  # ... Persona Definition
  name        = var.lab_persona[1]
  topic       = var.lab_topic 
  knowledge   = "Uefa Euro 2024 and the location ${var.lab_topic}" 
  role        = "I am a  ${var.lab_context}" 
  messageText = "I can help you during your visit to ${var.lab_topic} and the Uefa Euros 2024"
  imageUrl    = "https://storage.googleapis.com/spls/arc-images/euro2024/helga.png"
  time        = "17 May"
  endpoint    = "/v1/v1"
}
