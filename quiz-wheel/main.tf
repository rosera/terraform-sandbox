# Arcade Wheel
# Description: Create dynamic content for labs
# Example: Football Leagues

resource random_integer "league_index" {
  min = 0
  max = length(var.leagues) -1
}

resource random_integer "member_index" {
  min = 0
  max = length(var.leagues[local.league_index].members ) -1
}

locals {
  // Define List Members
  leagues      = [for leagues in var.leagues : leagues.league]
  league_teams = [for leagues in var.leagues : leagues.members]

  // Define random index
  league_index = random_integer.league_index.result
  lab_index    = random_integer.member_index.result

  random_league       = local.leagues[local.league_index]
  random_league_teams = local.league_teams[local.league_index]
  random_match_team   = local.league_teams[local.league_index][local.lab_index]
}
