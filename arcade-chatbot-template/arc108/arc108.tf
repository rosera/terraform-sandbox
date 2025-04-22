# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Chris", "Susan" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Grammy winners"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Grammy award winners knowledge agent"
}


## Grammy Award Winners
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
      "title" = "Which Album of the Year was won by a former 1 Direction member?"
      "answer" = "Harrys House By Harry Styles"
      "members" = [
        "Harrys House By Harry Styles",
        "We Are By Jon Batiste",
        "Folklore by Taylor Swift",
        "When We All Fall Asleep, Where Do We Go? by Billie Eilish",
      ]
    },
    {
      "title" = "Which record of the Year was sung by a bond theme singer?"
      "answer" = "Everything I Wanted by Billie Eilesh"
      "members" = [
        "About Damn Time by Lizzo",
        "Leave the Door Open by Bruno Mars",
        "Everything I Wanted by Billie Eilesh",
        "This is America by Childish Gambino",
      ]
    },
    {
      "title" = "Which Song of the Year was sung by a former Destinys Child?"
      "answer" = "Break My Soul by Beyonce"
      "members" = [
        "Just Like That by Bonnie Raitt",
        "Break My Soul by Beyonce",
        "Leave the Door Open by Bruno Mars",
        "Bad Guy by Billie Eilesh",
      ]
    },
    {
      "title" = "Which Best New Artist sung about getting their drivers licence?"
      "answer" = "Olivia Rodrigo"
      "members" = [
        "Olivia Rodrigo",
        "Megan Thee Stallion",
        "Billie Eilesh",
        "Dua Lipa",
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
