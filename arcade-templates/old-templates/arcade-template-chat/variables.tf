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
  type        = string
  description = "key file location"
}

## Soccer National Leagues
## Type constraint:
## title: String representing the title of the List e.g. "English Premier League"
## members: List of Strings, separate each item with a comma e.g. "Arsenal", "Newcastle"
variable "lab_list" {
  type = list(object({
    title   = string
    members = list(string)
  }))
  default = [
    {
      "title" = "English Premier League"
      "members" = [
        "Manchester City",
        "Arsenal FC",
        "Manchester Utd",
        "Newcastle Utd",
      ]
    },
    {
      "title" = "Spanish Liga"
      "members" = [
        "Real Madrid",
        "Barcelona",
      ]
    },
    {
      "title" = "Italian Serie A"
      "members" = [
        "Atalanta",
        "Roma",
      ]
    },
    {
      "title" = "German Bundesliga"
      "members" = [
        "Bayern Munich",
        "Wolfsburg",
      ]
    }
  ]
}


## Task information 
variable "tasks" {
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
