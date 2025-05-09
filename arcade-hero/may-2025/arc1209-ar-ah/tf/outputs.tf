## --------------------------------------------------------------
## Custom variable defintions
## --------------------------------------------------------------

# Terraform Output values
output "service_url" {
  value = module.la_cloud_run.gcr_service_url
}

output "bucket" {
  value = "${var.gcp_project_id}-${var.gcp_bucket_name}"
}

output "repo" {
  value = "test-repo"
}

output "dataset" {
  value = "sports"
}

output "lab_topic" {
  value = local.lab_topic
}

## Startup Script Variables
## --------------------------------------------------------------

variable "gcp_icon" {
  type        = string
  description = "Resource Icon"
  # default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/virtual_private_cloud.png"
  default     = "https://storage.googleapis.com/spls/arc-hero/assets/images/cloud_firewall_rules.png"
}

## GETTER: storage.get_storage
output "gcs_bucket_name" {
  value = "${var.gcp_project_id}-${var.gcp_bucket_name}"
}

## GETTER: bq.get_dataset
output "bq_dataset_name" {
  value = "sports"
}

## GETTER: source.get_project_repo
output "source_repo_name" {
  value = "devsite"
}

## GETTER: pubsub.get_topic 
output "pubsub_topic_name" {
  value = "sports_topic"
}

## GETTER: pubsub.get_subscription 
output "pubsub_sub_name" {
  value = "sports_subscription"
}

## GETTER: vpc.get_network
output "vpc_network1_name" {
  value = "${var.gcp_vpc1_name}"
}

## GETTER: vpc.get_network
output "vpc_network2_name" {
  value = "${var.gcp_vpc2_name}"
}

## GETTER: vpc.get_subnetwork
output "vpc_subnetwork1_name" {
  value = "${var.gcp_subnet1_name}"
}

## GETTER: TBC 
output "fw_rule1_name" {
  value = "${var.gcp_fw1_name}"
}

## GETTER: TBC 
output "fw_rule1_direction" {
  value = "${var.gcp_direction1_name}"
}

## GETTER: TBC 
output "fw_target1_tag" {
  value = "${var.gcp_target1_tag}"
}

## GETTER: TBC 
output "fw_target2_tag" {
  value = "${var.gcp_target2_tag}"
}

## GETTER: TBC 
output "log_sink_name" {
  value = "lab-sink"
}

## GETTER: TBC 
output "iam_sa_name" {
  value = "lab-sink"
}

## GETTER: TBC 
output "ar_repo_name" {
  value = "${var.gcp_ar_1_name}"
}

## GETTER: TBC 
output "ar_repo_type" {
  value = "${var.gcp_ar_1_type}"
}
