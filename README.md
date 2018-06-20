bastion_IP = 35.204.11.162
someinternalhost_IP = 10.164.0.3

gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
  --metadata-from-file startup-script='#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
git clone -b monolith https://github.com/express42/reddit.git
cd reddit 
bundle install
puma -d'

gcloud compute firewall-rules create default-puma-server\
 --direction=INGRESS\
 --priority=1000\
 --network=default\
 --action=ALLOW\
 --rules=tcp:9393\
 --source-ranges=0.0.0.0/0\
 --target-tags=puma-server

 testapp_IP=35.204.231.87
 testapp_port = 9292
