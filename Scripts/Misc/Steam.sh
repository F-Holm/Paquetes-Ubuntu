#!/usr/bin/env bash

sudo wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo apt install -y ./steam.deb
sudo rm ./steam.deb
