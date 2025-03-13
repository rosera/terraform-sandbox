#!/bin/sh
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Environment Variables
CLUSTER_NAME=rewards-cluster
REGION=$2

# Set the Platform Project
gcloud config set project "$1"

# Enable services
gcloud services enable \
    alloydb.googleapis.com \
    artifactregistry.googleapis.com \
    cloudbuild.googleapis.com \
    container.googleapis.com \
    run.googleapis.com \
    pubsub.googleapis.com \
    workflows.googleapis.com \
    eventarc.googleapis.com \
    workflowexecutions.googleapis.com \
    servicenetworking.googleapis.com \
    cloudresourcemanager.googleapis.com \
    vpcaccess.googleapis.com \
    compute.googleapis.com \
    --quiet

# Create a GKE Autopilot cluster
gcloud container clusters create-auto $CLUSTER_NAME --region $REGION --async
