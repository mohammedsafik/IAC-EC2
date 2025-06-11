#!/bin/bash

# Update and install Docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -aG docker ec2-user

# Pull and run NGINX container
docker run -d -p 80:80 nginx
