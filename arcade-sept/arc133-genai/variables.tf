#
# ------------------  Qwiklabs Values
#
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

variable "container_image" {
  type = string
  description = "key file location"
  default     = "arcade-frontend-chatv3"
}

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Pierre", "Mathilde" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "2024 French Olympics, sprint events"
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
      "title" = "Which iconic Parisian venue will host the athletics events, including the sprints, during the 2024 Olympics?"
      "answer" = "Stade de France"
      "members" = [
        "Stade Roland Garros",
        "Parc des Princes",
        "Stade de France",
        "Accor Arena",
      ]
    },
    {
      # Index: 1
      "title" = "What is the shortest sprint distance contested at the Olympics?"
      "answer" = "100 meters"
      "members" = [
        "100 meters",
        "200 meters",
        "400 meters",
        "800 meters",
      ]
    },
    {
      # Index: 2
      "title" = "Besides individual sprint events, which other type of sprint race is featured in the Olympic athletics program?"
      "answer" = "Relay"
      "members" = [
        "Hurdles",
        "Steeplechase",
        "Relay",
        "Marathon",
      ]
    },
    {
      # Index: 3
      "title" = "How many gold medals are awarded for sprint events (including relays) in the Olympic athletics program?"
      "answer" = "9"
      "members" = [
      "5",
      "7",
      "9",
      "11",
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
