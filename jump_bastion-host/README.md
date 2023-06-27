# Creating a Bastion host on AWS
This page contains instructions to create a bastion host in AWS.

## Goals
-Only the Bastion host is accessible from the internet via SSH
  - This should be improved further to allow access only to known IPs, which could be dynamically changing depending on where you connect.
  - All other servers must be internal and SSH access should be limited to Bastion host.

# Create a Bastion instance
## Create AWS Linux2 Instance using this as cloud-init
- ```https://raw.githubusercontent.com/vivechanchanny/poc/main/jump_bastion-host/cloud-init.sh```
> If you forgot to create the instance with user data you can wget this file and execute it
## Configure Bastion
#### Assign role to the bastion host
Select the bastion host instance. Actions/Security/Modify IAM role and create a new administrative role for the bastion host.
### Configure SSH keys for creating internal/application server 
> Note: EC2 Instance connect is a better approach than this. However, instance connect as of today works only on Amazon Linux and Ubuntu. 
SSH access to all other hosts should go through Bastion. The private key to log in to other hosts should be kept only on Bastion. While creating the instances use this key name bastion-to-other-hosts-key.
- ```wget https://raw.githubusercontent.com/vivechanchanny/poc/main/utils/create-ssh-key.sh -O create-ssh-key.sh```
- ```bash create-ssh-key.sh```

### Create a security group and attach it to the bastion instance
In the future when new instances are created allow network access to it from this security group "outgoing-from-bastion-secgrp".
- Login to bastion as ec2-user
- ```https://raw.githubusercontent.com/vivechanchanny/poc/main/jump_bastion-host/create_and_assign_secgrp.sh -O create_and_assign_secgrp.sh```
- Create a security group by name outgoing-from-bastion-secgrp and attach it to the bastion instance
  - ```bash create_and_assign_secgrp.sh outgoing-from-bastion-secgrp```


### Configure public IP
I reserved an elastic IP in AWS and assign it to the bastion host. 

# HAProxy
 I run haproxy load balancer on Bastion insted of using AWS LOAD BALANCER 
- create and assign a security group 
  - ```wget https://raw.githubusercontent.com/vivechanchanny/poc/main/jump_bastion-host/loadbalancer-cf.yml -O loadbalancer-cf.yml```
  - ```aws cloudformation create-stack --stack-name loadbalancer-stack --template-body file://loadbalancer-cf.yml  --parameters ParameterKey=MySecurityGroup,ParameterValue=outgoing-from-loadbalancer-secgrp```
  - ```wget https://raw.githubusercontent.com/vivechanchanny/poc/main/jump_bastion-host/assign_secgrp.sh -O assign_secgrp.sh```
  - ```bash assign_secgrp.sh outgoing-from-loadbalancer-secgrp```
  - ```sleep 5 && aws cloudformation delete-stack --stack-name loadbalancer-stack```
- Install haproxy
  - ```sudo wget https://raw.githubusercontent.com/vivechanchanny/poc/main/jump_bastion-host/install_haproxy.sh -O install_haproxy.sh```
  - ```bash install_haproxy.sh```
- update the ```/etc/haproxy/haproxy.cfg``` by changing all occurrences of ```apacheserver.local``` with with the ```private IP``` address of the lamp instance.
- ```systemctl restart haproxy```
- ```systemctl enable haproxy```
### Configure TLS ( To be done )
should start with this documentation letsencrypt is free  [letsencrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-centos-7)  
