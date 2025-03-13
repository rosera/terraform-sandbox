resource "google_pubsub_topic" "example" {
  name = "cf_topic"
  project = var.gcp_project_id

  labels = {
    foo = "cf-demo"
  }

  # message_retention_duration = "86600s"
}
