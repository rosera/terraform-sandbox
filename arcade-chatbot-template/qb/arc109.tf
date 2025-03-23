# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Pierre", "Mathilde" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "French"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Bienvenue à Français 101"
}

## lab_list: Questions to be shown in the lab
## Type Constraint: Members == 4 | There are four options presented
## title: String representing the title of the List e.g. "History, Ge
## members: List of Strings, separate each item with a comma e.g. "Pa

variable "lab_list" {
  type = list(object({
    title = string
    answer = string
    members = list(string)
  }))
  default = [
    {
      "title" = "Who was the penultimate child of Empress Maria Theresa and Emperor Francis I?"
      "answer" = "Marie Antoinette"
      "members" = [
        "Louis XIV",
        "Louis XV",
        "Louis XVI",
        "Marie Antoinette",
      ]
    },
    {
      "title" = "Which is the largest administrative region in France by area?"
      "answer" = "Nouvelle-Aquitaine"
      "members" = [
        "Brittany",
        "Corsica",
        "Nouvelle-Aquitaine",
        "Paris",
      ]
    },
    {
      "title" = "Which French artist was known for use of colour and draughtsmanship?"
      "answer" = "Henri Matisse"
      "members" = [
        "Claude Monet",
        "Vincent van Gogh",
        "Paul Cézanne",
        "Henri Matisse",
      ]
    },
    {
      "title" = "Which French Celebrity is affectionately known as little sparrow?"
      "answer" = "Edith Piaf"
      "members" = [
        "Napoleon Bonaparte",
        "Marie Curie",
        "Jean Reno",
        "Edith Piaf",
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
