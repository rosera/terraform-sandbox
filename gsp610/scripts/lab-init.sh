#!/bin/bash

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script 
cat << 'EOF' > cloudbuild.yaml 
steps:
- id: startup_script 
  name: 'ubuntu'
  env:
  - 'REPO_NAME=${_REPO_NAME}'
  - 'FILE_PATH=${_FILE_PATH}'
  script: |
    apt update
    apt install -y git python3 pip
    cd /workspace
    git clone $REPO_NAME
    cd /workspace/$FILE_PATH
    virtualenv -p python3 env
    source env/bin/activate
    pip3 install Flask==2.0.0 \
    google-cloud-firestore==2.1.1 \
    google-cloud-storage==1.38.0 \
    google-cloud-logging==2.3.0 \
    google-cloud-error-reporting==1.1.2 \
    gunicorn==20.1.0 \
    six==1.16.0
- id: deploy_app_engine 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  args: ['gcloud', 'app', 'deploy', '-q']
  dir: '${_HOME_DIR}'
timeout: 900s
substitutions:
  _REPO_NAME: https://github.com/GoogleCloudPlatform/getting-started-python    # Repo
  _FILE_PATH: getting-started-python/bookshelf                                 # Filepath
  _HOME_DIR: /workspace/getting-started-python/bookshelf                       # Directory
EOF

# Initiate CloudBuild Trigger 
gcloud builds submit --config=cloudbuild.yaml --project="$1"
