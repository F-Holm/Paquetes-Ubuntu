#!/usr/bin/env bash

sudo wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo apt install -y ./discord.deb
sudo rm ./discord.deb
