#!/bin/bash
sudo yup update -y
sudo yum search docker
sudo yum install docker -y
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) 
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -aG docker ec2-user

#Create the dockerfile
sudo mkdir /home/ec2-user/project
sudo chmod 777 -R /home/ec2-user/project
export DOCKER_PASS=<PASSWORD>
export DOCKER_USER=<USER>
sudo echo "Docker Apache static site by Jhon" > /home/ec2-user/project/index.html
sudo printf "FROM ubuntu:latest\n\nRUN apt-get -y update\nRUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata\nRUN apt-get install -y apache2 curl\nEXPOSE 80\nWORKDIR /var/www/html\nCOPY project/index.html /var/www/html/index.html\nENTRYPOINT [\"/usr/sbin/apache2ctl\"]\nCMD [\"-D\", \"FOREGROUND\"]" > /home/ec2-user/project/Dockerfile
echo $DOCKER_PASS | docker login --username $DOCKER_USER --password-stdin
sudo docker build . -t apacheserver -f /home/ec2-user/project/Dockerfile
sudo docker run -d --name apache1 apacheserver