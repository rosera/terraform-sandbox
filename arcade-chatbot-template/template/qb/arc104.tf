# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Kobe", "Catlin" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Basketball"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "National Basketball knowledge agent"
}

sketball National Leagues
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
      "title" = "Which basketball team plays in San Francisco?"
      "answer" = "Golden State Warriors"
      "members" = [
        "Boston Celtics",
        "Golden State Warriors",
        "Los Angeles Lakers",
        "Miami Heat",
      ]
    },
    {
      "title" = "Which Euro League team has their stadium at Palau Blaugrana?"
      "answer" = "FC Barcelona"
      "members" = [
        "Anadolu Efes Istanbul",
        "FC Barcelona",
        "Olympiacos",
        "Panathinaikos",
      ]
    },
    {
      "title" = "Which Australia Basketball team play at the snakepit?"
      "answer" = "Cairns Taipans"
      "members" = [
        "Adelaide 36ers",
        "Brisbane Bullets",
        "Cairns Taipans",
        "Melbourne United",
      ]
    },
    {
      "title" = "Which China Basketball League team play at the Cadillac Arena?"
      "answer" = "Beijing Ducks"
      "members" = [
        "Guangdong Southern Tigers",
        "Liaoning Flying Leopards",
        "Shanghai Sharks",
        "Beijing Ducks",
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
