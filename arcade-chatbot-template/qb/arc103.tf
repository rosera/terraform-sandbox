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
  default     = "National Cricket"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "National Cricket leagues knowledge agent"
}


## Cricket National Leagues
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
      "title" = "Which India Premier league team has the home ground M. A. Chidambaram Stadium?"
      "answer" = "Chennai Super Kings"
      "members" = [
        "Mumbai Indians",
        "Chennai Super Kings",
        "Kolkata Knight Riders",
        "Royal Challengers Bangalore",
        "Delhi Capitals",
      ]
    },
    {
      "answer" = "Which Big Bash League team has the home ground The Gabba?"
      "title" = "Brisbane Heat"
      "members" = [
        "Adelaide Strikers",
        "Brisbane Heat",
        "Hobart Hurricanes",
        "Melbourne Stars",
      ]
    },
    {
      "title" = "Who won the Ram Slam T20 Challenge in 2022?"
      "answer" = "Titans"
      "members" = [
        "Dolphins",
        "Cape Cobras",
        "Lions",
        "Titans",
      ]
    },
    {
      "title" = "Who won the Pakistan Super League in 2023?"
      "answer" = "Lahore Qalandars",
      "members" = [
        "Islamabad United",
        "Karachi Kings",
        "Lahore Qalandars",
        "Multan Sultans",
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
