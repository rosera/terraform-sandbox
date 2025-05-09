def step_one_check(handles:, maximum_score:, resources:)
  logging = handles['project_0.LoggingV2']

  # Assessment score and status checker hash variable
  ret_hash = {:score => 0, :message => "", :student_message=> "" }

  # Assessment specific variables
  lab_time = 5400
  lab_start_time = Time.at(Time.now.to_i - lab_time)

  # Filters for creation of the Artifact Repository
  ar_repo_name    = resources['project_0']['startup_script.ar_repo_name']
  ar_repo_type    = resources['project_0']['startup_script.ar_repo_type']

  ## Logs Explorer values
  # protoPayload.methodName="google.devtools.artifactregistry.v1.ArtifactRegistry.CreateReposito
  # protoPayload.serviceName="artifactregistry.googleapis.com"
  # protoPayload.request.repositoryId="prod-registry"
  # protoPayload.request.repository.format="DOCKER"
  # severity>=NOTICE
  # operation.first="true"

  # Filters for creation of the Artifact Repository
  methodName      = 'protoPayload.methodName:"ArtifactRegistry.CreateRepository"'
  serviceName     = 'protoPayload.serviceName="artifactregistry.googleapis.com"'
  repositoryId    = 'protoPayload.request.repositoryId="' + ar_repo_name + '"'
  request_format  = 'protoPayload.request.repository.format="' + ar_repo_type + '"'
  operation_first = 'operation.first="true"'
  severity        = 'severity>=NOTICE'

  # List_log_entries_request_object
  list_log_entries_request_object = Google::Apis::LoggingV2::ListLogEntriesRequest.new

  # Parent resource to track
  list_log_entries_request_object.resource_names = ['projects/' + logging.project]

  # API call to list available log entries against filter
  list_log_entries_request_object.filter = 'timestamp>"' + lab_start_time.utc.iso8601+ '" AND ' + methodName + ' AND ' + repositoryId + ' AND ' + request_format + ' AND ' + serviceName + ' AND ' + operation_first + ' AND ' + severity
  artifact_repository_logs = logging.list_entry_log_entries(list_log_entries_request_object)&.entries || []

  if artifact_repository_logs.count > 0
    ret_hash = {:score => maximum_score, :message => "Assessment Completed!", :student_message => "Assessment Completed!"}
  elsif artifact_repository_logs.count == 0
    error_message = "Please create the Artifact Repository name."
    ret_hash[:message] = error_message
    ret_hash[:student_message] = error_message
  end
  return ret_hash
end
