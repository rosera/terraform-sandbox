#------------------------------------------------------------------------------
# Unit Test 

## unit_testx_name
output "unit_test1_name" {
  value = var.unit_test1_name 
}

## unit_testx_task
output "unit_test1_task" {
  value = var.unit_test1_task 
}


#------------------------------------------------------------------------------
# Startup Script Values 

output "bq_dataset_name" {
  description = "Name of the BigQuery dataset"
  value       = module.la_bq_dataset.bq_dataset_id
}

output "bq_table_name" {
    value       = module.la_bq_table.bq_table_id
      description = "Name of the BigQuery Table"
}
