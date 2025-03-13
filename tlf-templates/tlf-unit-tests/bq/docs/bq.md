## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.22.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | 5.22.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_la_bq_dataset"></a> [la\_bq\_dataset](#module\_la\_bq\_dataset) | gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/bq_dataset/stable | n/a |
| <a name="module_la_bq_table"></a> [la\_bq\_table](#module\_la\_bq\_table) | gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/basics/bq_table/stable | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | The GCP project ID to create resources in. | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | Region to create resources in. | `string` | n/a | yes |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | Zone to create resources in. | `string` | n/a | yes |
| <a name="input_unit_test1_name"></a> [unit\_test1\_name](#input\_unit\_test1\_name) | Description of Resource e.g. BQ Dataset | `string` | `"BQ Dataset"` | no |
| <a name="input_unit_test1_task"></a> [unit\_test1\_task](#input\_unit\_test1\_task) | Description of action to be tested  e.g. Resource created. | `string` | `"Create Resource"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_unit_test1_name"></a> [unit\_test1\_name](#output\_unit\_test1\_name) | # unit\_testx\_name |
| <a name="output_unit_test1_task"></a> [unit\_test1\_task](#output\_unit\_test1\_task) | # unit\_testx\_task |
