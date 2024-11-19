#!/bin/bash -e
echo "STARTUP-SCRIPT: START"
## Git clone the training-data-analyst repo as Jupyter user
sudo -u jupyter git clone https://github.com/GoogleCloudPlatform/training-data-analyst /home/jupyter/training-data-analyst
echo "STARTUP-SCRIPT: END"
