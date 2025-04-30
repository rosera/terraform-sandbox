# Module: Persona 
#-----------------------------------------------------------------------------
module "persona_one" {
  # TODO: Move source to terraform-lab-foundations
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/set_persona/stable"

  # ... Persona Definition
  name        = var.lab_persona[0]
  topic       = var.lab_topic 
  knowledge   = var.lab_topic 
  role        = "I am a  ${var.lab_context}" 
  messageText = "I can help you during your visit to ${var.lab_topic}"
  imageUrl    = "https://storage.googleapis.com/spls/arc-images/persona/persona-1.png"
  time        = "29 May"
  endpoint    = "/v1/v1"
}

module "persona_two" {
  # TODO: Move source to terraform-lab-foundations
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/set_persona/stable"

  # ... Persona Definition
  name        = var.lab_persona[1]
  topic       = var.lab_topic 
  knowledge   = var.lab_topic 
  role        = "I am a  ${var.lab_context}" 
  messageText = "I can help you during your visit to ${var.lab_topic}"
  imageUrl    = "https://storage.googleapis.com/spls/arc-images/persona/persona-2.png"
  time        = "17 May"
  endpoint    = "/v1/v1"
}

#-----------------------------------------------------------------------------
# Create a bucket object containing a dynamically generated question
# The question can be anything.
# Example: Generate a question based on the data defined in lab_list

resource "google_storage_bucket_object" "persona_object" {
  name   = "persona.json"
  bucket = module.la_gcs.gcs_bucket_name

  ## Encode a question in JSON format
  content = jsonencode({
    "persona": [
      for persona in local.personas : {
        name        = persona.name
        topic       = persona.topic
        knowledge   = persona.knowledge
        role        = persona.role
        messageText = persona.messageText
        imageUrl    = persona.imageUrl
        time        = persona.time
        endpoint    = persona.endpoint
      }
    ],
  })
}

