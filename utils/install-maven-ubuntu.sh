#! /bin/bash


wget https://mirrors.sonic.net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O apache-maven-3.6.3-bin.tar.gz 
tar xzvf apache-maven-3.6.3-bin.tar.gz
sudo rm -rf /opt/apache-maven-3.6.3
rm -f apache-maven-*-bin.tar.gz
sudo mv apache-maven-3.6.3 /opt
echo "export PATH=\$PATH:/opt/apache-maven-3.6.3/bin" >> ~/.bashrc
