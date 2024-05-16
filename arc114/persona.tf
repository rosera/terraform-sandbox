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
  name        = "Marco"
  topic       = "Google Cloud Professional Cloud Architect"
  knowledge   = "Revision for Google Cloud Professional Cloud Architect" 
  role        = "I am a tutor on Google Cloud" 
  messageText = "I can help you revise for the Professional Cloud Architect exam"
  imageUrl    = "https://storage.googleapis.com/spls/arc-images/gcp-arch-badge.png"
  time        = "1 Jan"
  endpoint    = "/v1/v1"
}
