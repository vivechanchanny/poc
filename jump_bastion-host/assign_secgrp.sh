if [[ $1 == "" ]]
then
        echo "Usage: $0 your-security-group"
        exit 1
fi
myinstanceid=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
echo "my instance id number is $myinstanceid"
current_security_groups=$(aws ec2 describe-instances --instance-ids $myinstanceid --query Reservations[].Instances[].SecurityGroups[*].GroupId --output text)
echo "my instance id number is $current_security_groups"
newsecuritygroupId=$(aws ec2 describe-security-groups --group-names $1 --query SecurityGroups[*].GroupId --output text)
echo $newsecuritygroupId
aws ec2 modify-instance-attribute --instance-id $myinstanceid --groups $current_security_groups $newsecuritygroupId
