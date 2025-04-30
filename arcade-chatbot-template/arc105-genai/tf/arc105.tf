# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Tim", "Mary" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Resort hotels"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Worlds best hotel resorts knowledge agent"
}


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
      "title" = "Which beach resort is a private island created by volcanoes and preserved by coral reefs?"
      "answer" = "The Brando, French Polynesia"
      "members" = [
        "Amanyara, Turks and Caicos",
        "Round Hill Hotel and Villas, Jamaica",
        "Bawah Reserve, Indonesia",
        "The Brando, French Polynesia",
      ]
    },
    {
      "title" = "Which resort is situated on 400 acres of manicured ground with two miles of private beachfront?"
      "answer" =  "Half Moon, Jamaica"
      "members" = [
        "Half Moon, Jamaica",
        "The Peninsula Shanghai, China",
        "The Ritz-Carlton, New York, Central Park, USA",
        "The Landmark Mandarin Oriental, Hong Kong, China",
      ]
    },
    {
      "title" = "Which resort is situated in a 5.6km lagoon?"
      "answer" =  "Soneva Jani, Maldives"
      "members" = [
        "Beaches Turks and Caicos, Providenciales, Turks and Caicos",
        "Round Hill Hotel and Villas, Jamaica",
        "Soneva Jani, Maldives",
        "Jumby Bay Island, Antigua and Barbuda",
      ]
    },
    {
      "title" = "Which resort includes a 7 mile beach?"
      "answer" = "Beaches Negril, Jamaica"
      "members" = [
        "Beaches Turks and Caicos, Providenciales, Turks and Caicos",
        "Beaches Negril, Negril, Jamaica",
        "Beaches Ocho Rios, Ocho Rios, Jamaica",
        "Beaches Resort Barbados, Barbados",
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
