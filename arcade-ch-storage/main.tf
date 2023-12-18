# Arcade Wheel
# Description: Create dynamic content for labs
# Example: Cloud Storage Media 

locals {
  random_time1            = "2pm"
  random_time2            = "4pm"
  random_weekday          = "Monday"
  random_requestor        = "Beth"
  random_requestor_role   = "Development team lead"
  random_task             = "access to a public storage bucket"
  random_topic            = "serve media from Google Cloud Storage"
  random_product          = "Google Cloud Storage bucket"
  random_stakeholder_name = "Amelia"
  random_stakeholder_role = "Finance Director"
  random_duration         = "30 mins"
  random_bucket_name      = "${var.gcp_project_id}-bucket"
  random_test_filename    = "cloud-hero.txt"
}
