if [[ -e /home/ec2-user/.ssh/id_rsa ]]
then
    echo "ssh key file already exists. Exiting"
    exit 0
fi

# TBD RUn describe keys and check if the key is in aws.
ssh-keygen -t rsa -b 4096 -C "bastion to internal server"  -f /home/ec2-user/.ssh/id_rsa -P ""
aws ec2 delete-key-pair --key-name "bastion-to-other-hosts-key"

aws ec2 import-key-pair --key-name "bastion-to-other-hosts-key" --public-key-material fileb://~/.ssh/id_rsa.pub
