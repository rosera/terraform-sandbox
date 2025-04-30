# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Pavan", "Aarya" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Hindi"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "हिदी 101 म आपका सवागत ह"
}


## lab_list: Questions to be shown in the lab
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
      "title" = "Which dish is similar to butter chicken?"
      "answer" = "Murgh Makhani"
      "members" = [
        "Murgh Makhani",
        "Biryani",
        "Samosa",
        "Masala Dosa",
      ]
    },
    {
      "title" = "Which city is a financial center and the largest city in India?"
      "answer" = "Mumbai"
      "members" = [
        "New Delhi",
        "Mumbai",
        "Kolkata",
        "Bangaluru",
      ]
    },
    {
      "title" = "Which Indian artist used a modified cubist style?"
      "answer" = "M.F. Husain"
      "members" = [
        "Raja Ravi Varma",
        "Amrita Sher-Gil",
        "M.F. Husain",
        "S.H. Raza",
      ]
    },
    {
      "title" = "Which personality played international cricket and was a former captain in all formats?"
      "answer" = "Virat Kohli"
      "members" = [
        "Amitabh Bachchan",
        "Shah Rukh Khan",
        "Priyanka Chopra Jonas",
        "Virat Kohli",
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
