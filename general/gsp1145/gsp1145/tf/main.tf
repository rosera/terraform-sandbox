# Module: Google BigQuery Dataset 
module "la_bq_dataset" {
  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/bq_dataset/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  # bq_location = "US"
  bq_dataset_id = "dh"
  bq_dataset_friendly_name = "Data Hunt"
  bq_dataset_description = "Data Hunt Lab environment"
}

# Module: Google BigQuery Table 
module "la_bq_table" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/bq_table/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCS instance
  bq_dataset_id        = "datasetname"
  bq_table_id          = "exampletable"
  bq_table_description = "Example table"
}

# Module: Google BigQuery Table 
## module "la_bq_job" {
##   source = "github.com/CloudVLab/terraform-lab-foundation//basics/bq_job_load/stable"
## 
##   # Pass values to the module
##   gcp_project_id = var.gcp_project_id
##   gcp_region     = var.gcp_region
##   gcp_zone       = var.gcp_zone
## 
##   # Customise the GCS instance
##   bq_dataset_id        = "datasetname"
##   bq_table_id          = "exampletable"
##   bq_job_id            = "examplejob"
##   bq_location          = "US"
## 
##   # Label is an Object
##   bq_job_label         = { "my_job" = "lab_job" }
## 
##   # Source is set a Cloud Storage Bucket
##   bq_job_source        = [ "gs://datasource" ]
## 
##   # Data type set as CSV | JSON | AVRO
##   bq_job_format        = "CSV"
## }

