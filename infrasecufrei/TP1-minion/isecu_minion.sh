#!/bin/bash
apt-get update -y
apt-get install -y fish zsh fzf docker.io docker-compose git avahi-daemon 
docker pull portainer/portainer:latest
docker volume create portainer_data
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name portainer portainer/portainer:latest
echo "portainer_url: http://$(hostname):9000"


apt install awesome -y 
apt install xinit -y
echo "startx"
apt install firefox -y