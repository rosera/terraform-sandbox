# Arcade Adventure 

Data driven labs based on Terraform input.

## Usage

Update the following:

- [ ] variables.tf: Common values defined for the modules.

```
lab_topic
lab_context
lab_code
```

## Modules
- [x] api.tf - Enable Googleapis 
- [x] base64.tf - Create base64 token as JSON, output variable 
- [x] cf.tf - Create Cloud Run function set custom service account 
- [x] cr.tf - Create Cloud Run service 
- [x] gcs.tf - Create a Cloud Storage Bucket 
- [x] role.tf - Use the custom service account and bind to a permission
- [x] sa.tf - Create a custom service account and bind to role
- [x] outputs.tf - exposed variables
- [x] variables.tf - variable definitions

