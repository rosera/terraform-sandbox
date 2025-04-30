# Define Persona + Question Bank


variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Pierre", "Mathilde" ]
}


variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "2024 French Olympics, Nice events"
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
## members: List of four Strings, separate each item with a comma e.g. "Paris", "Napoleon"

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
      "title" = "Which aquatic disciplines will be showcased at the Nice Stadium during the 2024 Olympics?"
      "answer" = "Artistic Swimming, Diving, Water Polo"
      "members" = [
        "Swimming, Diving, Water Polo",
        "Artistic Swimming, Diving, Water Polo",
        "Synchronized Swimming, Water Polo, Open Water Swimming",
        "Diving, Water Polo, Triathlon",
      ]
    },
    {
      # Index: 1
      "title" = "The iconic Promenade des Anglais in Nice will host which Olympic event?"
      "answer" = "Triathlon"
      "members" = [
        "Marathon",
        "Cycling Road Race",
        "Triathlon",
        "Beach Volleyball",
      ]
    },
    {
      # Index: 2
      "title" = "Which combat sports will share the same venue in Nice during the 2024 Olympics?"
      "answer" = "Judo and Wrestling"
      "members" = [
        "Judo and Karate",
        "Taekwondo and Wrestling",
        "Judo and Wrestling",
        "Boxing and Fencing",
      ]
    },
    {
      # Index: 3
      "title" = "Besides the main stadium, which other venue in Nice will host Olympic events?"
      "answer" = "There is no other venue in Nice hosting Olympic events"
      "members" = [
        "Allianz Riviera",
        "Palais Nikaia",
        "There is no other venue in Nice hosting Olympic events",
        "Parc Phoenix",
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
