output "lab_user" {
  value = confluent_invitation.lab_user
}

output "confluent_environment" {
  value = {
    display_name = confluent_environment.qlab.display_name
  }
}