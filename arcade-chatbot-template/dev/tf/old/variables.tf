## Qwiklabs information 
## ----------------------------------------------------------------------------

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "service_account_key_file" {
  type = string
  description = "key file location"
}

## Task information 
## ----------------------------------------------------------------------------

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

## Custom information 
## ----------------------------------------------------------------------------

variable "container_image" {
  type = string
  description = "key file location"
  default     = "arcade-frontend-chatv2"
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Portuguese"
}

variable "lab_persona" {
  type        = string
  description = "Person to interact with in the chatbot"
  default     = "Beatriz"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Bem-vindos ao Português 101"
}


## Lab List information 
## ----------------------------------------------------------------------------

## lab_list: Questions to be shown in the lab
## Type Constraint: Members == 4 | There are four options presented
## title: String representing the title of the List e.g. "History, Geography, Artists"
## members: List of Strings, separate each item with a comma e.g. "Paris", "Napoleon"

variable "lab_list" {
  type = list(object({
    title = string
    members = list(string)
  }))
  default = [
    {
      "title" = "Brazil foods"
      "members" = [
        "Feijoada",
        "Churrasco",
        "Pao de Queijo",
        "Brigadeiro",
      ]
    },
    {
      "title" = "Regions of Brazil"
      "members" = [
        "Rio de Janeiro",
        "São Paulo",
        "Salvador",
        "Brasilia",
      ]
    },
    {
      "title" = "Brazil Artists"
      "members" = [
        "Tarsila do Amaral",
        "Oscar Niemeyer", 
        "Candido Portinari",
        "Romero Britto",
      ]
    },
    {
      "title" = "Brazil celebrities"
      "members" = [
        "Gisele Bundchen",
        "Neymar Jr",
        "Anitta",
        "Rodrigo Santoro",
      ]
    },
    {
      "title" = "Brazil landmarks"
      "members" = [
        "Cristo Redentor",
        "Pao de Acucar",
        "Foz do Iguacu",
        "Amazon Rainforest",
      ]
    }
  ]
}
