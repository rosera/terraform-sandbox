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
  default     = "European Football leagues"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "European top tier soccer leagues"
}


## Soccer National Leagues
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
      "title" = "Who won the English Premier League in 2023?"
      "answer" = "Manchester City"
      "members" = [
        "Manchester City",
        "Arsenal FC",
        "Manchester Utd",
        "Newcastle Utd",
      ]
    },
    {
      "title" = "Who won the Spanish Liga in 2023?"
      "Barcelona"
      "members" = [
        "Real Madrid",
        "Barcelona",
				"Athletico Madrid",
        "Valencia",
      ]
    },
    {
      "title" = "Who won the Italian Serie A in 2023?"
      "answer" = "Napoli"
      "members" = [
        "Napoli",
        "Roma",
        "Inter Milan",
        "Juventus",
      ]
    },
    {
      "title" = "Who won the German Bundesliga 2023?"
      "answer" = "Bayern Munich"
      "members" = [
        "Bayern Munich",
        "Wolfsburg",
        "Dortmund",
        "Hoffenheim",
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
