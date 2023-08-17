#!/bin/bash

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script 
cat << 'EOF' > cloudbuild.yaml 
steps:
- id: bucket_access 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  - 'BUCKET_NAME=${_BUCKET_NAME}'
  script: |
    #!/bin/bash

    ## SCRIPT START
    echo "Script for ${PROJECT_ID} - Replace with cool script"

    # Make the bucket public with view permissions
    gsutil uniformbucketlevelaccess set off gs://${BUCKET_NAME}
    ## SCRIPT END 
   
- id: bucket_web 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  - 'BUCKET_NAME=${_BUCKET_NAME}'
  script: |
    #!/bin/bash

    ## SCRIPT START
    echo "Script for ${PROJECT_ID} - Replace with cool script"

    # Enable static website hosting for the bucket.
    # gsutil web set -m index.html -e 404.html gs://${BUCKET_NAME}
    gsutil web set -m index.html gs://${BUCKET_NAME}

    # Make the bucket public with view permissions
    gsutil iam ch allUsers:objectViewer gs://${BUCKET_NAME}
    ## SCRIPT END 
   
timeout: 900s
substitutions:
  _PROJECT_ID: project_id
  _BUCKET_NAME: bucket_name 
options:
  substitution_option: 'ALLOW_LOOSE'
EOF

# Initiate CloudBuild Trigger 
# Ensure no spaces in substitutions
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1",_BUCKET_NAME="$2"
