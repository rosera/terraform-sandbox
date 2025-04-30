#!/bin/bash
export PROJECT_ID="$1"

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script
cat << 'EOF' > cloudbuild.yaml
steps:
- id: bucket_copy 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  script: |
    #!/bin/bash
    ## SCRIPT START
    # Copy across remote files
    gsutil -m cp -R gs://spls/arc-genai-chatv2 gs://${PROJECT_ID}-bucket
    gsutil -m cp -R gs://spls/arc-genai-chatv2/Dockerfile /workspace 
    gsutil -m cp -R gs://spls/arc-genai-chatv2/nginx/default.conf /workspace 
    gsutil -m cp -R gs://spls/arc-genai-chatv2/nginx /workspace 
    gsutil -m cp -R gs://spls/arc-genai-chatv2/web-v2 /workspace 
    ## SCRIPT END
- id: bucket_config
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  script: |
    #!/bin/bash
    ## SCRIPT START
    # Copy across remote files
    gsutil cp gs://${PROJECT_ID}-bucket/tasks.json /workspace
    # Add the generated tasks.json 
    gsutil cp gs://${PROJECT_ID}-bucket/tasks.json gs://${PROJECT_ID}-bucket/arc-genai-chatv2/assets/config/tasks.json
    ## SCRIPT END
- id: image_build 
  name: 'gcr.io/cloud-builders/docker'
  id: 'build_container'
  args: ['build', '-t', '${_REPO_NAME}/$PROJECT_ID/${_TAG_NAME}/${_IMAGE_NAME}:${_IMAGE_VERSION}',
        '-t', '${_REPO_NAME}/$PROJECT_ID/${_TAG_NAME}/${_IMAGE_NAME}',
           '.']
# SET TIMEOUT TO SCRIPT DURATION 
timeout: 1500s
substitutions:
  _PROJECT_ID: project_id
  _IMAGE_VERSION: 0.0.1
  _IMAGE_NAME: arcade-frontend-chatv2 
  _REVISION_NAME: latest
  _TAG_NAME: arcade 
  _REPO_NAME: gcr.io 
options:
  substitution_option: 'ALLOW_LOOSE'

images:
  - '${_REPO_NAME}/$PROJECT_ID/${_TAG_NAME}/${_IMAGE_NAME}:${_REVISION_NAME}'
  - '${_REPO_NAME}/$PROJECT_ID/${_TAG_NAME}/${_IMAGE_NAME}:${_IMAGE_VERSION}'
tags: [ '${_IMAGE_NAME}' ]
EOF

#Initiate CloudBuild Trigger
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1",_IMAGE_NAME="$4" 
