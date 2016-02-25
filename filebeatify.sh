#!/bin/bash
echo "deb https://packages.elastic.co/beats/apt stable main" |  sudo tee -a /etc/apt/sources.list.d/beats.list
sudo apt-get update
sudo apt-get -y install filebeat

# make configuration changes

sudo service filebeat restart
sudo update-rc.d filebeat defaults 95 10