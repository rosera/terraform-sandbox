# Objective: Check if the PubSub Subscription exists
def pubsub_subscription_check(handles:, maximum_score:, resources:)

  pubsub   = handles['project_0.PubsubV1']
  sub_name = 'projects/' + pubsub.project + '/subscriptions/' + resources['project_0']['startup_script.pubsub_sub_name']

  # Assessment specific variables
  isAvailable = false

  # Assessment score and status checker hash variable
  ret_hash = { :score => 0, :message => "", :student_message => ""}

  # Check if the object exists
  resource_object = pubsub.get_subscription(sub_name.to_s) || []

  # Check the bucket object identity
  if resource_object
    isAvailable = true
  end

  if isAvailable
    ret_hash = { :score => maximum_score, :message => "Assessment completed!", :student_message => "Assessment completed!"}
  else
    error_message = 'Please create a PubSub Topic.'
    ret_hash[:message] = error_message
    ret_hash[:student_message] = error_message
  end
  return ret_hash
end
