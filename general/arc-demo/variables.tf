# Qwiklabs Mandatory Values
variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

## variable "service_account_key_file" {
##   type        = string
##   description = "QL service account key"
## }


## National Leagues
variable "leagues" {
  type = list(object({
    league = string
    members = list(string)
  }))
  default = [
    {
      "league" = "English Premier League"
      "members" = [
        "Manchester City",
        "Arsenal FC",
        "Manchester Utd",
        "Newcastle Utd",
      ]
    },
    {
      "league" = "Spanish Liga"
      "members" = [
        "Real Madrid",
        "Barcelona",
      ]
    },
    {
      "league" = "Italian Seria A"
      "members" = [
        "Atalanta",
        "Roma",
      ]
    },
    {
      "league" = "German Bundesliga"
      "members" = [
        "Bayern Munich",
        "Wolfsburg",
      ]
    }
  ]
}


## Task information 
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
