for value in $(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId"  --output=text); do     aws ec2 delete-security-group --group-id $value ; done
