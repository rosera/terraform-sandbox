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
      "league" = "German Bundesliga"
      "members" = [
        "Bayern Munich",
        "Wolfsburg",
      ]
    }
  ]
}

