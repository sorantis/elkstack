#!/bin/bash
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list

echo "#############################"
echo "#### Installing Packages ####
echo "#############################"
sudo apt-get update
sudo apt-get -y install unzip
sudo apt-get -y install openjdk-7-jre
sudo apt-get --force-yes -y install elasticsearch
sudo apt-get --force-yes -y install logstash
sudo apt-get --force-yes -y install kibana

echo "#############################"
echo "### Enabling Beats Plugins ##"
echo "#############################"
# Instal beats plugin for logstash
sudo /opt/logstash/bin/plugin install logstash-input-beats
sudo /opt/logstash/bin/plugin update logstash-input-beats

echo "#############################"
echo "### Copying Config Files ####"
echo "#############################"
# Copy logstash configuration files
sudo cp conf/logstash/* /etc/logstash/conf.d/

echo "#############################"
echo "##### Starting Services #####"
echo "#############################"
sudo service elasticsearch start
sudo service logstash start
sudo service kibana start

echo "#############################"
echo "##### Beats Dashboards ######"
echo "#############################"
# Install beats dashboards
curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.1.zip
unzip -o beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh
cd ..

curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@conf/filebeat.template.json


#sudo service logstash restart
#sudo update-rc.d logstash defaults 96 9