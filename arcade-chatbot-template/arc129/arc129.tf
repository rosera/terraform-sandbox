# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Hans", "Helga" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Munich, Germany"
}


variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Tour guide for the Uefa Euros 2024"
}

## lab_list: Questions to be shown in the lab
## Type: There are four options presented
## title: String representing the title of the List e.g. "History, Geography, Artists"
## answer: String representing the question answer
## members: List of Strings, separate each item with a comma e.g. "Paris", "Napoleon"

## Constraint: Members == 4

variable "lab_list" {
  type = list(object({
    title = string
    answer = string
    members = list(string)
  }))

  # ProTip use the Chatbot to generate the questions and answers
  # Could you make a quick two question quiz on XXXX?
  # It should have four options and the correct answer included?
  # Please indicate the correct answer in the response.

  default = [
    {
      # Index: 0
      "title" = "What is the name of the stadium where the 2024 UEFA European Championship final will be held?"
      "answer" = "Allianz Arena"
      "members" = [
        "Olympiastadion",
        "Munich Olympic Stadium",
        "Munich Arena",
        "Allianz Arena",
      ]
    },
    {
      # Index: 1
      "title" = "What is the name of the river that runs through Munich?"
      "answer" = "Isar River"
      "members" = [
        "Danube River",
        "Isar River",
        "Rhine River",
        "Elbe River",
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
