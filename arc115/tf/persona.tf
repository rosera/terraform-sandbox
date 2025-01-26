#-----------------------------------------------------------------------------
# Arcade Wheel
# Description: Dynamic content for labs
# Ref: variables.tf lab_list

# Module: Persona 
#-----------------------------------------------------------------------------
module "persona_one" {
  # TODO: Move source to terraform-lab-foundations
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/set_persona/stable"

  # ... Persona Definition
  name        = var.lab_persona
  topic       = var.lab_topic 
  knowledge   = "Revision for ${var.lab_topic}" 
  role        = "I am a tutor on ${var.lab_context}" 
  messageText = "I can help you revise for the ${var.lab_topic} exam"
  imageUrl    = "https://storage.googleapis.com/spls/arc-images/gcp-arch-badge.png"
  time        = "1 Jan"
  endpoint    = "/v1/v1"
}
