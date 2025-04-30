# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Rodrigo", "Marie" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Portuguese"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Bem-vindos ao Português 101"
}


## lab_list: Questions to be shown in the lab
## Type Constraint: Members == 4 | There are four options presented
## title: String representing the title of the List e.g. "History, Geography, Artists"
## members: List of Strings, separate each item with a comma e.g. "Paris", "Napoleon"

variable "lab_list" {
  type = list(object({
    title = string
    answers = string
    members = list(string)
  }))

  default = [
    {
      "title" = "What is the name of a traditional Brazilian black bean stew?"
      "answer" = "Feijoada"
      "members" = [
        "Feijoada",
        "Churrasco",
        "Pao de Queijo",
        "Brigadeiro",
      ]
    },
    {
      "title" = "Which regions of Brazil is known for its Portuguese colonial architect and tropical coastline?"
      "answer" = "Salvador"
      "members" = [
        "Rio de Janeiro",
        "São Paulo",
        "Salvador",
        "Brasilia",
      ]
    },
    {
      "title" = "Which Brazilian artist combines elements of cubism, pop art, and graffiti painting in his work?"
      "answer" = "Romero Britto"
      "members" = [
        "Tarsila do Amaral",
        "Oscar Niemeyer",
        "Candido Portinari",
        "Romero Britto",
      ]
    },
    {
      "title" = "Which Brazilian actor appeared in Westworld, 300 and Love Actually?"
      "answer" = "Rodrigo Santoro"
      "members" = [
        "Gisele Bundchen",
        "Neymar Jr",
        "Anitta",
        "Rodrigo Santoro",
      ]
    },
    {
      "title" = "What is the Portuguese name of the landmark Sugarloaf Mountain?"
      "answer" = "Pao de Acucar"
      "members" = [
        "Cristo Redentor",
        "Pao de Acucar",
        "Foz do Iguacu",
        "Amazon Rainforest",
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
