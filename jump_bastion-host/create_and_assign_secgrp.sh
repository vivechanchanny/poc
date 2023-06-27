if [[ $1 == "" ]]
then
        echo "Usage $0 outgoing-from-bastion-secgrp"
        exit 1
fi
aws ec2 create-security-group --description "Bastion security group to access to other hosts" --group-name $1 --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=access-via-bastion}]" --query GroupId --output text

wget https://raw.githubusercontent.com/vivechanchanny/wordpress-serverlesss/main/bastion/assign_secgrp.sh -O assign_secgrp.sh
bash assign_secgrp.sh $1
