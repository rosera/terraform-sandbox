#!/bin/bash
sudo apt update

sudo apt install git -y

sudo mkdir /deployment

cd /deployment

sudo git clone https://github.com/neo4j-partners/google-deployment-manager-neo4j.git

cd google-deployment-manager-neo4j

cd scripts

cd neo4j-enterprise

sed -i -e 's/n1-standard-4/e2-standard-4/g' parameters.single.yaml

./deploy.sh neo4j single

gcloud compute instances delete startup-vm --zone var.gcp_zone --quiet