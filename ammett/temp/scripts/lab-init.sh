#!/bin/bash
apt update -y
apt install mariadb-server -y
systemctl enable mariadb
