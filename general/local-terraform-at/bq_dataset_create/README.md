# BigQuery Dataset Create

## Activity Tracking

Checks if a dataset exists

* BigqueryV2 googleapi

```
  bigquery     = handles['project_0.BigqueryV2']
  dataset_name = resources['project_0']['startup_script.bq_dataset_name']
```

In the above code, the resources definition accesses a startup script value.

## Generate

To generate the file, use Terraform to create the output file.
Amend the `variables.tf` file to name the file to be created.

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
