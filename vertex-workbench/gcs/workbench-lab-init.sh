#!/bin/bash -e
echo "STARTUP-SCRIPT: START"
# Download Path File
gsutil cp gs://spls/tlf-workbench/workbench.patch /tmp/workbench.patch

## Amend ACL
sudo -u jupyter patch /home/jupyter/.jupyter/jupyter_notebook_config.py < /tmp/workbench.patch

# Restart the service
sudo -u jupyter sudo systemctl restart jupyter.service

## Git clone the training-data-analyst repo as Jupyter user
sudo -u jupyter git clone https://github.com/GoogleCloudPlatform/training-data-analyst /home/jupyter/training-data-analyst
echo "STARTUP-SCRIPT: END"
