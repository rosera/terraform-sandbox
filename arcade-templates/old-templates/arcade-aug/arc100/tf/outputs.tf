
// Bucket
#resource "random_integer" "bucket_suffix" {
#  min = 10000
#  max = 99999
#}

output "bucket" {
  value       = "memories-bucket-${var.gcp_project_id}"
  description = "Name of the bucket."
}

// Topic

resource "random_integer" "topic_suffix" {
  min = 100
  max = 999
}

output "topic" {
  value       = "memories-topic-${random_integer.topic_suffix.result}"
  description = "Name of the topic."
}

// Function

resource "random_shuffle" "function_suffix" {
  input        = ["generator", "creator", "maker"]
  result_count = 1
}

output "function" {
  value       = "memories-thumbnail-${random_shuffle.function_suffix.result[0]}"
  description = "Name of the function."
}
