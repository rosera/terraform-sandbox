# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Sai", "Mei" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Mandarin"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "欢迎来到汉语101"
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
      "title" = "Which Chinese dynasty is credited with trade expansion to the outside world?"
      "answer" = "Ming Dynasty"
      "members" = [
        "Qin Dynasty",
        "Han Dynasty",
        "Tang Dynasty",
        "Ming Dynasty",
      ]
    },
    {
      "title" = "Which Chinese City is the capital and largest city of Guangdong province in southern China?"
      "answer" = "Guangzhou"
      "members" = [
        "Beijing",
        "Shanghai",
        "Guangzhou",
        "Shenzhen",
      ]
    },
    {
      "title" = "Which Chinese artist is credited with a playful style for their watercolor works?"
      "answer" = "Qi Baishi"
      "members" = [
        "Qi Baishi",
        "Xu Beihong",
        "Zhang Daqian",
        "Ai Weiwei",
      ]
    },
    {
      "title" = "Which Chinese celebrity starred in Hero?"
      "answer" = "Jet Li"
      "members" = [
        "Jackie Chan",
        "Gong Li",
        "Jet Li",
        "Zhang Ziyi",
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
