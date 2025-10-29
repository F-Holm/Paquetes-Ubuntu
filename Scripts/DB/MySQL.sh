#!/usr/bin/env bash

# MySQL
sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.32-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.32-1_all.deb
sudo apt update
sudo apt install -y mysql-server
sudo mysql_secure_installation
sudo snap install mysql-workbench-community
sudo rm mysql-apt-config_0.8.32-1_all.deb
