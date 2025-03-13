# Objective: Verifies the creation of the bucket
def storage_bucket_check(handles:, maximum_score:, resources:)

  # Service handle initialization
  storage     = handles['project_0.StorageV1']
  bucket_name = resources['project_0']['startup_script.bucket']

  # Assessment score and status checker hash variable
  ret_hash = { :score => 0, :message => "", :student_message => ""}

  # Assessment specific variables
  isAvailable = false

  # Check if the bucket exists
  bucket = storage.get_bucket(bucket_name.to_s) || []
  if bucket.id
    isAvailable = true
  end

  if isAvailable 
    ret_hash = { :score => maximum_score, :message => "Assessment completed!", :student_message => "Assessment completed!"}
  else
    error_message = 'Please create the storage bucket.'
    ret_hash[:message] = error_message
    ret_hash[:student_message] = error_message
  end

  return ret_hash
end
