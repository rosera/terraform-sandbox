# Generic Activity Tracking

Use these Terraform scripts to generate generic activity tracking code.

| Service | Method | Action |
|---------|--------|--------|
| BigQuery | get_dataset | Check if a `dataset` is defined within a project |
| Cloud Storage | get_bucket | Check if a `storage bucket` is defined within a project |
| Firewall | get_firewall | Check if a `firewall rule` is defined within a project |
| Logging | get_sink | Check if a `log sink` is defined within a project |
| PubSub | get_topic | Check if a `Topic` is defined within a project |
| PubSub | get_subscription | Check if a `Subscription` is defined within a project |
| Source Repo | get_repo | Check if a `Repository` is defined within a project |
| Compute | get_network | Check if a `network` is defined within a project |
| Compute | get_subnetwork | Check if a `subnetwork` is defined within a project |


## Setup

1. Amend the `variables.tf` file to set the name the `step` to be generated.


```terraform
variable "step_name" {
  type        = string
  description = "The name of the step to be created"
  default     = "bigquery_dataset_check"
}
```

__Note:__ The Terraform `default` value will determine the name of:

- [ ] The file to be generated
- [ ] The name of the method to be created

## Generate

To generate the file, use Terraform to create the output file.

1. Initialise the folder 
```
terraform init
```

2. Validate the code
```
terraform validate
```

3. Create the activity tracking code file
```
terraform apply -auto-approve
```

4. Optional: To remove the file created
```
terraform destroy -auto-approve
```
