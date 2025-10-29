#!/usr/bin/env bash

sudo curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
sudo echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
sudo wget https://downloads.mongodb.com/compass/mongodb-compass_1.45.4_amd64.deb
sudo apt install -y ./mongodb-compass_1.45.4_amd64.deb
sudo rm ./mongodb-compass_1.45.4_amd64.deb
