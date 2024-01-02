resource "confluent_invitation" "lab_user" {
  email = var.qlUsername
  auth_type = "AUTH_TYPE_LOCAL"
}

resource "confluent_environment" "qlab" {
  display_name = "qlab-${confluent_invitation.lab_user.user[0].id}"
  depends_on = [ confluent_invitation.lab_user ]
}

resource "confluent_role_binding" "role_bind_env_admin" {
  principal	= "User:${confluent_invitation.lab_user.user[0].id}"
  role_name	= "EnvironmentAdmin"
  crn_pattern	= confluent_environment.qlab.resource_name
  depends_on = [ confluent_environment.qlab ]
}