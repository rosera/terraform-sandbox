#!/bin/bash

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script 
cat << 'EOF' > cloudbuild.yaml 
steps:
- id: drl_recruit_data 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  script: |
    #!/bin/bash

    ## SCRIPT START
    bq mk drl
    sleep 10s
    for file in `gsutil ls gs://spls/gsp394/tables/*.csv`; do TABLE_NAME=`echo $file | cut -d '/' -f6 | cut -d '.' -f1`; bq load --autodetect --source_format=CSV --replace=true drl.$TABLE_NAME $file; done
    ## SCRIPT END 

timeout: 900s
substitutions:
  _PROJECT_ID: project_id
options:
  substitution_option: 'ALLOW_LOOSE'
EOF

# Initiate CloudBuild Trigger 
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1"
