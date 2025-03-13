#!/bin/sh
# Mandatory Prefix
echo "STARTUP-SCRIPT START"
sudo apt-get update -y
sudo apt-get install -y apache2
sudo systemctl start apache2
# # Mandatory Postfix
echo "STARTUP-SCRIPT END"
