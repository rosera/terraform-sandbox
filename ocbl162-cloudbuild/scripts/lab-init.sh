#!/bin/bash
export PROJECT_ID="$1"
export REGION="$2"
export ZONE="$3"

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script
cat << 'EOF' > cloudbuild.yaml
steps:
- id: datafusion_script 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  - 'REGION=${_REGION}'
  - 'ZONE=${_ZONE}'
  script: |
    #!/bin/bash
    ## SCRIPT START
    # gcloud services disable datafusion.googleapis.com --force
    # sleep 3
    # gcloud services enable datafusion.googleapis.com
    sleep 60 
    # CloudBuild SA bind roles/datafusion.admin
    gcloud beta data-fusion instances create --location="${REGION}" --zone="${ZONE}" cdf-lab-instance --enable_stackdriver_logging
    #CHECK=`gcloud beta data-fusion instances list --location=us-central1 | grep datafusion.googleusercontent.com | wc -l`
    #if [ $CHECK -eq 1 ]; then
    #  gcloud beta runtime-config configs variables set success/training-vm success --config-name training-vm-config; break;
    #fi
    ## SCRIPT END
# SET TIMEOUT TO SCRIPT DURATION 
timeout: 1500s
substitutions:
  _PROJECT_ID: project_id
  _REGION: region
  _ZONE: zone
options:
  substitution_option: 'ALLOW_LOOSE'
EOF

#Initiate CloudBuild Trigger
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1",_REGION="$2",_ZONE="$3"
