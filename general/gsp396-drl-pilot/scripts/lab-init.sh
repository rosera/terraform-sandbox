#!/bin/bash

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script 
cat << 'EOF' > cloudbuild.yaml 
steps:
- id: drl_pilot_data 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  script: |
    #!/bin/bash

    ## SCRIPT START
    gsutil -m cp gs://spls/gsp396/lab2.csv gs://${PROJECT_ID}-bucket
    ## SCRIPT END 
- id: python_notebook 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  script: |
    #!/bin/bash

    ## SCRIPT START
    gsutil -m cp gs://spls/gsp396/notebook.ipynb gs://${PROJECT_ID}-bucket
    ## SCRIPT END 
- id: update_notebook 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  script: |
    #!/bin/bash

    ## SCRIPT START
    # Download Python Notebook
    gsutil -m cp gs://${PROJECT_ID}-bucket/notebook.ipynb .
    # REPLACE "PROJECT_ID"
    sed -i "s/PROJECT_ID/${PROJECT_ID}/g" notebook.ipynb
    # REPLACE "BUCKET_ID"
    sed -i "s/BUCKET_ID/${PROJECT_ID}-bucket/g" notebook.ipynb
    # Upload Python Notebook
    gsutil -m cp notebook.ipynb gs://${PROJECT_ID}-bucket/notebook.ipynb
    ## SCRIPT END 
timeout: 900s
substitutions:
  _PROJECT_ID: project_id
options:
  substitution_option: 'ALLOW_LOOSE'
EOF

# Initiate CloudBuild Trigger 
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1"
