#!/bin/sh
# Mandatory Prefix
echo "STARTUP-SCRIPT START"

sudo apt-get update
sudo apt-get install dnsutils -y
sudo apt-get install jq -y

gcloud compute firewall-rules delete default-allow-rdp --quiet
gcloud compute firewall-rules delete default-allow-ssh --quiet
gcloud compute firewall-rules delete default-allow-internal --quiet
gcloud compute firewall-rules delete default-allow-icmp --quiet
gcloud compute networks delete default --quiet

# Mandatory Postfix
echo "STARTUP-SCRIPT END"