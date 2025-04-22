# Define Persona + Question Bank

riable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Pierre", "Mathilde" ]
}

## Lab Data List
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "2024 French Olympics, Marseille events"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Tour guide for the Paris Olympics 2024"
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
      "title" = "Which sporting venue in Marseille will host the sailing competitions during the 2024 Olympics?"
      "answer" = "Marseille Marina"
      "members" = [
        "Stade Velodrome",
        "Parc Chanot",
        "Marseille Marina",
        "Palais des Sports",
      ]
    },
    {
      # Index: 1
      "title" = "Apart from sailing, which other Olympic sport will be contested in the waters off Marseille?"
      "answer" = "Marathon Swimming"
      "members" = [
        "Rowing",
        "Canoeing",
        "Triathlon",
        "Marathon Swimming",
      ]
    },
    {
      # Index: 2
      "title" = "Which iconic landmark in Marseille will serve as the backdrop for the marathon swimming events?"
      "answer" = "Château dIf"
      "members" = [
        "Notre-Dame de la Garde",
        "Vieux Port",
        "Château dIf",
        "MuCEM",
      ]
    },
    {
      # Index: 3
      "title" = "How many sailing medal events are scheduled to take place in Marseille during the 2024 Olympics?"
      "answer" = "10"
      "members" = [
        "6",
        "8",
        "10",
        "12",
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
