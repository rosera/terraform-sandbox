# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Pablo", "Maria" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Spanish"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Bienvenidos a Español 101"
}

## Type Constraint: Members == 4 | There are four options presented
## title: String representing the title of the List e.g. "History, Geography, Artists"
## members: List of Strings, separate each item with a comma e.g. "Paris", "Napoleon"

variable "lab_list" {
  type = list(object({
    title = string
    answer = string
    members = list(string)
  }))
  default = [
    {
      "title" = "Which monarch was known as the Holy Roman Emperor?"
      "answer" = "Charles I"
      "members" = [
        "Isabella I",
        "Charles I",
        "Philip II",
        "Felipe VI",
      ]
    },
    {
      "title" = "What is the Spanish name for the Basque Country?"
      "answer" = "Pais Vasco"
      "members" = [
        "Andalucia",
        "Cataluna",
        "Galicia",
        "Pais Vasco",
      ]
    },
    {
      "title" = "Which Spanish artists is most famous for combined abstract art and surrealist fantasy?"
      "answer" = "Joan Miro"
      "members" = [
        "Pablo Picasso",
        "Salvador Dali",
        "Francisco Goya",
        "Joan Miro",
      ]
    },
    {
      "title" = "Which Spanish celebrity was also a Bond villain?"
      "answer" = "Javier Bardem"
      "members" = [
        "Penelope Cruz",
        "Rafael Nadal",
        "Rosalia",
        "Javier Bardem",
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
