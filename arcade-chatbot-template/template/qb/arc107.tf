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
  default     = "Oscar winners"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Academy Award Winners knowledge agent"
}

## Academy Award Winners
## Type constraint:
## title: String representing the title of the List e.g. "English Premier League"
## members: List of Strings, separate each item with a comma e.g. "Arsenal", "Newcastle"
variable "lab_list" {

  type = list(object({
    title = string
    answers = string
    members = list(string)
  }))
  default = [
    {
      "title" = "Who won Best Director for The Hurt Locker?"
      "answer" = "Kathryn Bigelow"
      "members" = [
        "Steven Spielberg",
        "Martin Scorsese",
        "Kathryn Bigelow",
        "Bong Joon Ho",
      ]
    },
    {
      "title" = "Who won Best Actor for Training Day?"
      "answer" = "Denzel Washington"
      "members" = [
        "Daniel Day-Lewis",
        "Robert De Niro",
        "Jack Nicholson",
        "Denzel Washington",
      ]
    },
    {
      "title" = "Who won Best Actress for On Golden Pond?"
      "answer" = "Katheryn Hepburn"
      "members" = [
        "Katheryn Hepburn",
        "Vivien Leigh",
        "Ingrid Bergman",
        "Meryl Streep",
      ]
    },
    {
      "title" = "Bong Joon Ho and Jin Won Han won Best Screenplay for which movie?"
      "answer" = "Parasite"
      "members" = [
        "12 Angry Men",
        "Casablanca",
        "The Godfather",
        "Parasite",
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
