## Firebase Application Configuration

output "appId" {
  value       = "${google_firebase_web_app.basic.app_id}"
  description = "Firebase application Identifier."
}

output "apiKey" {
 value       = "${data.google_firebase_web_app_config.basic.api_key}"
  description = "Firebase API key."
}

output "authDomain" {
  value       = "${data.google_firebase_web_app_config.basic.auth_domain}"
  description = "Firebase authentication domain."
}

output "databaseURL" {
  value       = "${lookup(data.google_firebase_web_app_config.basic, "database_url", "")}"
  description = "Firebase authentication database url."
}

output "storageBucket" {
  value       = "${lookup(data.google_firebase_web_app_config.basic, "storage_bucket", "")}"
  description = "Firebase authentication storage bucket."
}

output "messageSenderId" {
  value       = "${lookup(data.google_firebase_web_app_config.basic, "messaging_sender_id", "")}"
  description = "Firebase authentication message sender identification."
}

output "measurementId" {
  value       = "${lookup(data.google_firebase_web_app_config.basic, "measurement_id", "")}"
  description = "Firebase authentication measurement identifier."
}

output "urlCloudShell" {
  # value       = "https://console.cloud.google.com/compute/instances?project=${var.gcp_project_id}&supportedpurview=project&cloudshell=true"
  # value       = "https://console.cloud.google.com/?project=${var.gcp_project_id}&supportedpurview=project&cloudshell=true"
  value       = "/?project=${var.gcp_project_id}&supportedpurview=project&cloudshell=true"
  description = "Open Cloud Shell from Compute homepage."
}
