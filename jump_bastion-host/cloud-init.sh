#!/bin/bash

echo "set -o vi" >> ~/.bashrc
sudo bash -c 'echo set -o vi >> ~root/.bashrc'

# Instruction can be found here https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html
sudo yum update -y
sudo yum install tree -y
# this works only on Amazon Linux 2
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
#Start the Apache web server.
sudo systemctl start httpd
sudo systemctl enable httpd
# verify if it is enabled
sudo systemctl is-enabled httpd
