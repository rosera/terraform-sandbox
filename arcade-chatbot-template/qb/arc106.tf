# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Bob", "Mary" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Michelin Restaurants"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Restaurants with Michelin Stars"
}


## Michelin Start 
## Type constraint:
## title: String representing the title of the List e.g. "English Premier League"
## members: List of Strings, separate each item with a comma e.g. "Arsenal", "Newcastle"
variable "lab_list" {

  type = list(object({
    title = string
    answer = string
    members = list(string)
  }))
  default = [
    {
      "title" = "Which Michelin star restaurant is based in Newcastle, England?"
      "answer" = "House of Tides" 
      "members" = [
        "The Man Behind The Curtain",
        "L'Enclume",
        "The Black Swan at Oldstead",
        "House of Tides",
      ]
    },
    {
      "title" = "Which Michelin star restaurant is based in Padua, Italy?"
      "answer" = "Le Calendre" 
      "members" = [
        "Il Convivio Troiani",
        "PER ME - Giulio Terrinoni",
        "Osteria Francescana",
        "Le Calandrе",
      ]
    },
    {
      "title" = "Which French Michelin star restaurant is in the Four Seasons hotel in Paris?"
      "answer" = "Le Cinq" 
      "members" = [
        "La Truffière",
        "Le Cinq",
        "Restaurant Kei",
        "Restaurant Frederic Simonin",
      ]
    },
    {
      "title" = "Which American Michelin star restaurant is based on San Francisco?"
      "answer" = "Benu" 
      "members" = [
        "EL ideas",
        "Goosefoot",
        "Alinea",
        "Benu",
      ]
    }
  ]
}


## Task information 
## tasks: JSON format used by the lab 
variable tasks {
  type = list(object({
    tag      = string
    question = string
    option_a = string
    option_b = string
    option_c = string
    option_d = string
  }))
  
  default = [
    {
      tag      = "Add a Task and number"
      question = "Add a question"
      option_a = "Add an option"
      option_b = "Add an option"
      option_c = "Add an option"
      option_d = "Add an option"
    }
  ]
}
