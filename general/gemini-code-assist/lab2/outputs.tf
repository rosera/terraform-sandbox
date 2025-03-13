output "connection_name" {
  value = google_sql_database_instance.default.connection_name
}

output "db_user_name" {
  value = google_sql_user.user.name
}

output "db_user_password" {
  value = google_sql_user.user.password
  sensitive = true
}

output "db_name" {
  value = google_sql_database.default.name
}
