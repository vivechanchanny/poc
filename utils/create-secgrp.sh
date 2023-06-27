if [[ $1 == "" ]]
then
        echo "Usage $0 name-secgrp"
        exit 1
fi
aws ec2 create-security-group --description "Bastion security group to access to other hosts" --group-name $1 --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=$1}]" --query GroupId --output text

