#! /bin/bash
if [[ "$1" == "" ]]; then
        echo "Usage $0 <value of tag Name of instance>"
        exit 1
fi
aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].{Instance:PublicIpAddress}" --output=text
