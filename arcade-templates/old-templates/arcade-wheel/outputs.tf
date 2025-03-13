## Expose Project properties

output "random_team" {
  value = local.random_match_team 
}

output "random_group" {
  value = local.random_league_teams 
}

output "random_league" {
  value = local.random_league 
}
