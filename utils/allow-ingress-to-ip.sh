#! /bin/bash
if [[ "$1" == "" || "$2" == "" || $3 = "" ]]; then
        echo "Usage $0 destgrp sourceip port"
        exit 1
fi

destinationgroup=$1
sourceip=$2
port=$3

mysecurityId=$(aws ec2 describe-security-groups --group-names $destinationgroup --query SecurityGroups[*].GroupId --output text)
echo $mysecurityId

aws ec2 authorize-security-group-ingress --group-id $mysecurityId --protocol tcp --port $port --cidr $sourceip
