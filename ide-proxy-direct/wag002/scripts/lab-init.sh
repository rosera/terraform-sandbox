#!/bin/sh
# Mandatory Prefix
echo "STARTUP-SCRIPT START"
echo "ACCOUNT: ide-dev"
sudo -u ide-dev mkdir -p /home/ide-dev/mysite/mysite
sudo -u ide-dev pip install wagtail
sudo -u ide-dev /home/ide-dev/.local/bin/wagtail start mysite /home/ide-dev/mysite
sudo -u ide-dev pip install -r /home/ide-dev/mysite/requirements.txt
sudo -u ide-dev /usr/bin/python3 /home/ide-dev/mysite/manage.py migrate
# # Mandatory Postfix
echo "STARTUP-SCRIPT END"
