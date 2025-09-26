
# Locals: Define the Lab Topic 
#-----------------------------------------------------------------------------
locals {
  ## Define a Lab topic
  lab_topic = "Cloud Run functions"
}


# Locals: Create Tasks list dynamically
# Description: Use interpolation to create custom values based on environment
#-----------------------------------------------------------------------------
locals {
  tasks = [
    # module.gcs_bucket_create.task,
    # module.bq_dataset_create.task,
    # module.vpc_network_create.task,
    # module.vpc_subnet_create.task,
    # module.pubsub_topic_create.task,
    # module.fw_inbound_create.task,
    # module.fw_outbound_create.task,
    # module.fw_sourcetag_create.task,
    # module.ar_container_create.task,
    module.cloud_functions_http.task,
    module.cloud_functions_pubsub.task,

    # ... Add more tasks
  ]
}


