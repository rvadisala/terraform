#!/bin/bash

sudo yum clean all && sudo yum install httpd -y
sudo systemctl enable --now httpd
sudo bash -c  'echo "Welcome to Apache webserver, Hosted using Terraform" > /var/www/html/index.html'
hostname -i | awk '{print $2}' | sudo tee -a  /var/www/html/index.html
sudo setenforce 0
