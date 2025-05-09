def step_one_check(handles:, maximum_score:, resources:)
  logging = handles['project_0.LoggingV2']

  # Assessment score and status checker hash variable
  ret_hash = {:score => 0, :message => "", :student_message=> "" }

  # Assessment specific variables
  lab_time = 5400
  lab_start_time = Time.at(Time.now.to_i - lab_time)

  # Filters for creation of the Artifact Repository
  cf_service_name = resources['project_0']['startup_script.cf_service_name']
  region          = resources['project_0']['default_region']
  project_id      = logging.project 

  ## Logs Explorer values
  # protoPayload.resourceName="projects/[PROJECT_ID]/locations/[REGION]/functions/[CF_SERVICE]"
  # protoPayload.methodName="google.cloud.functions.v2.FunctionService.CreateFunction"
  # operation.first="true"
  # severity>=NOTICE

  # Filters for creation of the Cloud Run functions 
  resource_name   = 'protoPayload.resourceName="projects/' + project_id + '/locations/' + region + '/functions/' + cf_service_name + '"'
  method_name     = 'protoPayload.methodName="google.cloud.functions.v2.FunctionService.CreateFunction"'
  operation_first = 'operation.first="true"'
  severity        = 'severity>=NOTICE'

  # List_log_entries_request_object
  list_log_entries_request_object = Google::Apis::LoggingV2::ListLogEntriesRequest.new

  # Parent resource to track
  list_log_entries_request_object.resource_names = ['projects/' + logging.project]

  # API call to list available log entries against filter
  # list_log_entries_request_object.filter = 'timestamp>"' + lab_start_time.utc.iso8601+ '" AND ' + methodName + ' AND ' + repositoryId + ' AND ' + request_format + ' AND ' + serviceName + ' AND ' + operation_first + ' AND ' + severity
  list_log_entries_request_object.filter = 'timestamp>"' + lab_start_time.utc.iso8601+ '" AND ' + method_name + ' AND ' + resource_name + ' AND ' + operation_first + ' AND ' + severity
  resource_logging = logging.list_entry_log_entries(list_log_entries_request_object)&.entries || []

  if resource_logging.count > 0 
    ret_hash = {:score => maximum_score, :message => "Assessment Completed!", :student_message => "Assessment Completed!"}
  elsif resource_logging.count == 0
    error_message = "Please create the Cloud Function."
    ret_hash[:message] = error_message
    ret_hash[:student_message] = error_message
  end
  return ret_hash
end
