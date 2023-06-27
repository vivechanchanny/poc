# Creating a Bastion host on AWS
This page contains instructions to create a bastion host in AWS.

## Goals
1. Only Bastion host is accessible from internet via SSH
  - This should be improved further to allow access only to only known IP's which could be dynamically changing depending on where you connect from.
  - Automatically configure the bastion security group allowed source IP's with the IP you are using to connect after 2FA check. https://aws.amazon.com/blogs/startups/securing-ssh-to-amazon-ec2-linux-hosts/
  - All other servers must be internal and SSH access should be limited to Bastion host.
2. Configure Mobaxterm to be able to access other internal hosts via Bastion
  - Edit Session->Network Settings->
  - Remote Host=internal host ip, username internal host username. In connect through ssh gateway use bastion settings

# Create Bastion instance
## Create AWS Linux2 Instance using this as cloud init
- ```https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/cloud-init.sh```
> If you forgot to create the instance with user-data you can wget this file and execute it
## Configure Bastion
#### Assign role to bastion host
Select the bastion host instance. Actions/Security/Modify IAM role and create a new administrative role to the bastion host.
### Configure SSH keys
> Note: EC2 Instance connect is a better apporach than this. However instance connect as of today works only on Amazon Linux and ubuntu. 
SSH access to all other hosts should go through Bastion. The private key to login to other hosts should be kept only on Bastion. While creating the instances use this key name bastion-to-other-hosts-key.
- ```wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/utils/create-ssh-key.sh -O create-ssh-key.sh```
- ```bash create-ssh-key.sh```
- For backup purpose download bastion-to-other-hosts-key.pem from bastion to your laptop and safestore it securely.

### Create security group and attach to bastion instance
In future when new instances are created allow network access to it from this security group "outgoing-from-bastion-secgrp".
- Login to bastion as ec2-user
- ```wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/create_and_assign_secgrp.sh -O create_and_assign_secgrp.sh```
- Create a security group by name outgoing-from-bastion-secgrp and attach it to bastion instance
  - ```bash create_and_assign_secgrp.sh outgoing-from-bastion-secgrp```


### Configure public IP
It is recommended to reserve an elastic IP in AWS and assign it to bastion host. This will help so that you don't need to change IP each time you restart Bastion. You can configure your domain and mobaxterm with this static IP you own.

# HAProxy
 I run haproxy load balancer on bastion insted of using AWS LOAD BALANCER 
  But below instructions can be run on any other instance that you plan to run the load balancer on.
- create and assign a security group 
  - ```wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/loadbalancer-cf.yml -O loadbalancer-cf.yml```
  - ```aws cloudformation create-stack --stack-name loadbalancer-stack --template-body file://loadbalancer-cf.yml  --parameters ParameterKey=MySecurityGroup,ParameterValue=outgoing-from-loadbalancer-secgrp```
  - ```wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/assign_secgrp.sh -O assign_secgrp.sh```
  - ```bash assign_secgrp.sh outgoing-from-loadbalancer-secgrp```
  - ```sleep 5 && aws cloudformation delete-stack --stack-name loadbalancer-stack```
- Install haproxy
  - ```sudo wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/install_haproxy.sh -O install_haproxy.sh```
  - ```bash install_haproxy.sh```
- update the ```/etc/haproxy/haproxy.cfg``` by changing all occurrences of apacheserver.local with with the ```private IP``` address of the lamp instance.
- ```systemctl restart haproxy```
- ```systemctl enable haproxy```
### Configure TLS ( To be done )
should start with this documentation letsencrypt is free  [letsencrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-centos-7)  