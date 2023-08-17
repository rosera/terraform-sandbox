#!/bin/sh
PROJECT="$1"

# Set the Platform project
gcloud config set project $PROJECT

# Delete Firewall rules
gcloud compute firewall-rules delete default-allow-icmp default-allow-ssh default-allow-internal default-allow-rdp --project=$PROJECT --quiet

# Delete VPC
gcloud compute networks delete default --project=$PROJECT --quiet
