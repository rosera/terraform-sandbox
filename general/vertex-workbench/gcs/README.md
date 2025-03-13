# Vertex AI Workbench

- [ ] patch file
- [ ] workbench-lab-init.sh
- [ ] lab-init.sh

## patch file

Create a patch file to update the Jupyter configuration.

* Amend the origin pat to allow Cloud Run regex
* Amend the ServerApp ip, set as host internal IP or wildcard.

```bash
i6c6,7
< c.ServerApp.allow_origin_pat = "(^https://8080-dot-[0-9]+-dot-devshell\.appspot\.com$)|(^https://colab\.(?:sandbox|research)\.google\.com$)|(^(https?://)?[0-9a-z\-]+\.[0-9a-z\-]+\.cloudshell\.dev$)|(^(https?://)ssh\.cloud\.google\.com/devshell$)"
---
> c.ServerApp.ip = "*"
> c.ServerApp.allow_origin_pat = "(^https://8080-dot-[0-9]+-dot-devshell\.appspot\.com$)|(^https://colab\.(?:sandbox|research)\.google\.com$)|(^(https?://)?[0-9a-z\-]+\.[0-9a-z\-]+\.cloudshell\.dev$)|(^(https?://)ssh\.cloud\.google\.com/devshell$)|(^(https?://)?[0-9a-z]+-[-0-9a-z]*.a.run.app)"
```

## workbench-lab-init.sh

Includes public access control list to make it accessible outside of Google Cloud.

* Clones training-data-analyst


```bash
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
```


## lab-init.sh

Standard access control list to not accessible outside of Google Cloud.


* Clones training-data-analyst

```bash
#!/bin/bash -e
echo "STARTUP-SCRIPT: START"
## Git clone the training-data-analyst repo as Jupyter user
sudo -u jupyter git clone https://github.com/GoogleCloudPlatform/training-data-analyst /home/jupyter/training-data-analyst
echo "STARTUP-SCRIPT: END"
```
