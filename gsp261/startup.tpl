#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Set variables
export zone=${zone}
export region=${region}

# SA GENERATION WORKAROUND: reenable these APIs
export PROJECT_ID=$(gcloud config get-value project)
if [[ $(gcloud services list | grep 'Cloud Composer') ]] && [[ $(gcloud projects get-iam-policy $PROJECT_ID | grep 'composer\.serviceAgent') ]]; then
  echo "Service Account already exists!"
else
  sleep 5
  gcloud services disable composer.googleapis.com --force
  gcloud services disable cloudbuild.googleapis.com --force
  gcloud services disable container.googleapis.com --force
  gcloud services enable container.googleapis.com
  gcloud services enable cloudbuild.googleapis.com
  gcloud services enable composer.googleapis.com
fi

# Clean-up this VM (not needed in lab)
# gcloud compute instances delete startup-vm --zone=$zone --quiet
