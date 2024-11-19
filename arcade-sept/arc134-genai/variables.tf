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
  default     = "2024 French Olympics, long distance events"
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
      "title" = "Which iconic Parisian landmark will serve as the starting and finishing point for the marathon events at the 2024 Olympics?"
      "answer" = "Hotel de Ville"
      "members" = [
        "Eiffel Tower",
        "Arc de Triomphe",
        "Louvre Museum",
        "Hotel de Ville",
      ]
    },
    {
    # Index: 1
      "title" = "Besides the marathon, which other long-distance running event is included in the Olympic athletics program?"
      "answer" = "50km Race Walk"
      "members" = [
        "10,000 meters",
        "3,000m Steeplechase",
        "50km Race Walk",
        "Half Marathon",
      ]
    },
    {
    # Index: 2
      "title" = "In which venue will the track cycling endurance events, such as the Madison and Omnium, be held during the 2024 Olympics?"
      "answer" = "Velodrome National de Saint-Quentin-en-Yvelines"
      "members" = [
        "Stade Pierre de Coubertin",
        "Velodrome National de Saint-Quentin-en-Yvelines",
        "La Chapelle Arena",
        "Pont d'Iena",
      ]
    },
    {
    # Index: 3
      "title" = "Which long-distance swimming event will take place in the Seine River during the 2024 Olympics?"
      "answer" = "10km Marathon Swim"
      "members" = [
        "1500m Freestyle",
        "4x200m Freestyle Relay",
        "10km Marathon Swim",
        "5km Open Water Swim",
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
