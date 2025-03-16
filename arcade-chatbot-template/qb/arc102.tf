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
  default     = "Rugby events"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Rugby National Leagues"
}


## Rugby National Leagues
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
      "title" = "Which Six Nations Rugby has the nickname Le Blues?"
      "answer" = "France"
      "members" = [
        "Ireland",
        "Italy",
        "Scotland",
        "Wales",
        "France",
        "England",
      ]
    },
    {
      "title" = "Which Rugby Championship side has the nickname the Springboks?"
      "answer" = "South Africa"
      "members" = [
        "Argentina",
        "Australia",
        "New Zealand",
        "South Africa",
      ]
    },
    {
      "title" = "Which World Rugby Sevens team has the nickname the All Blacks?"
      "answer" = "New Zealand"
      "members" = [
        "New Zealand",
        "Fiji",
        "France",
        "Australia",
      ]
    },
    {
      "title" = "Which Rugby World Cup team have the nickname the Thistles?"
      "answer" = "Scotland"
      "members" = [
        "France",
        "New Zealand",
        "South Africa",
        "Ireland",
        "Scotland",
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
