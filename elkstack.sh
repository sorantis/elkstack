#!/bin/bash
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list.d/kibana-4.4.x.list
echo 'deb http://packages.elastic.co/logstash/2.2/debian stable main' | sudo tee /etc/apt/sources.list.d/logstash-2.2.x.list

sudo apt-get update
sudo apt-get -y install unzip
sudo apt-get -y install openjdk-7-jre
sudo apt-get install -y python-pip

sudo apt-get --force-yes -y install elasticsearch

# Install management tools
sudo /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
pip install elasticsearch-curator

sudo service elasticsearch restart
sudo update-rc.d elasticsearch defaults 95 10

sudo apt-get --force-yes -y install logstash

# Install beats plugin for logstash
sudo /opt/logstash/bin/plugin install logstash-input-beats
sudo /opt/logstash/bin/plugin update logstash-input-beats

# Copy logstash configuration files
sudo cp conf/logstash/* /etc/logstash/conf.d/

sudo service logstash restart
sudo update-rc.d logstash defaults 96 9

sudo apt-get --force-yes -y install kibana
sudo service kibana start
sudo update-rc.d kibana defaults 96 9

while ! nc -q 1 localhost 9200 </dev/null; do sleep 3; done

curl --retry 20 -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@conf/filebeat.template.json

# Install beats dashboards
curl -L -O https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.1.zip
unzip -o beats-dashboards-1.1.1.zip > /dev/null 2>&1
cd beats-dashboards-1.1.1/
./load.sh
cd ..
