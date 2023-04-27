#!/bin/bash
sudo docker volume create yacht
sudo docker run -d -p 8000:8000 --name yatch -v /var/run/docker.sock:/var/run/docker.sock -v yacht:/config selfhostedpro/yacht
