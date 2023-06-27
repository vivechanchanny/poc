#!/usr/bin/env python

import boto3

# Connect to the Amazon EC2 service
ec2_client = boto3.client('ec2')

keypairs = ec2_client.describe_key_pairs()

for key in keypairs['KeyPairs']:
  if 'praveen' not in key['KeyName'].lower():
    print "Deleting key pair", key['KeyName']
    ec2_client.delete_key_pair(KeyName=key['KeyName'])
