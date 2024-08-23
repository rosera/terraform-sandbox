#!/bin/bash -e
echo "STARTUP-SCRIPT: START"
## Amend ACL
sudo -u jupyter sed -i '/c.ServerApp.ip /c\\nc.ServerApp.ip = \"*\"' /home/jupyter/.jupyter/jupyter_notebook_config.py
sudo -u jupyter sed -i '/c.ServerApp.allow_origin_pat/c\\nc.ServerApp.allow_origin_pat = \"((https?:\/\/)?[0-9a-z]+-[\-0-9a-z]*\.a\.run\.app)\"' /home/jupyter/.jupyter/jupyter_notebook_config.py
sudo -u jupyter sed -i '/c.ServerApp.allow_remote_access/c\\nc.ServerApp.allow_remote_access = True' /home/jupyter/.jupyter/jupyter_notebook_config.py

## Git clone the training-data-analyst repo as Jupyter user
sudo -u jupyter git clone https://github.com/GoogleCloudPlatform/training-data-analyst /home/jupyter/training-data-analyst
echo "STARTUP-SCRIPT: END"
