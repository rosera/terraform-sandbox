# Objective: Check if a log sink has been created
def log_sink_check(handles:, maximum_score:, resources:)
  log_sink  = handles['project_0.LoggingV2']
  log_sink_name = 'projects/' + log_sink.project + '/sinks/' + resources['project_0']['startup_script.log_sink_name']

  # Assessment specific variables
  isAvailable = false

  # Assessment score and status checker hash variable
  ret_hash = { :score => 0, :message => "", :student_message => ""}

  # Check if the topic exists
  resource_object = log_sink.get_sink(log_sink_name.to_s) || []

  # Validate object created
  if resource_object
    isAvailable = true
  end

  if isAvailable
    ret_hash = { :score => maximum_score, :message => "Assessment completed!", :student_message => "Assessment completed!"}
  else
    error_message = 'Please create a log sink.'
    ret_hash[:message] = error_message
    ret_hash[:student_message] = error_message
  end
  return ret_hash
end
