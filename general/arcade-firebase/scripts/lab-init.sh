#!/bin/bash

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script 
cat << 'EOF' > cloudbuild.yaml 
steps:
  # Copy across the remote files
  - id: copy_gcs
    name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    env:
      'PROJECT_ID=$PROJECT_ID'
    script: |
      #!/bin/bash
      ## SCRIPT START
      # Web App
      gsutil -m cp -r gs://spls/arc-genai-chat/web /workspace

      # Cloud Function
      # gsutil -m cp -r gs://spls/arc-genai-chat/functions /workspace

      # Firebase Configuration
      gsutil -m cp -r gs://$PROJECT_ID-fb-webapp/* /workspace
      ## SCRIPT END 

  # Firebase Hosting: Chat APP
  - id: firebase_hosting 
    # Custom community builder image 
    name: 'gcr.io/qwiklabs-resources/firebase'
    args: ['deploy', '--project=$PROJECT_ID', '--only=hosting']

  # Firebase Cloud Function: Cloud Storage Activity Tracking
  #  - id: firebase_functions
  #    # Custom community builder image 
  #    name: 'gcr.io/qwiklabs-resources/firebase'
  #    args: ['deploy', '--project=$PROJECT_ID', '--only=functions:createStorageFile']
timeout: 900s
options:
  substitution_option: 'ALLOW_LOOSE'
EOF

# Initiate CloudBuild Trigger 
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1"
