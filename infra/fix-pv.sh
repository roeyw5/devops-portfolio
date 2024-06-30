#!/bin/bash

# This script modifies the instance metadata options for all EC2 instances in a specific VPC.
# It ensures that the instances can get the required credentials for provisioning EBS volumes.
# The script fetches the VPC ID using the VPC name, retrieves the instance IDs in the VPC,
# and then modifies the instance metadata options to make the HTTP tokens optional.


# Set the VPC Name
VPC_NAME="roey-pf-vpc"

# Get the VPC ID using the VPC Name
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --query "Vpcs[0].VpcId" --output text)

# Check if the VPC ID was found
if [ "$VPC_ID" == "None" ]; then
  echo "Error: VPC with name $VPC_NAME not found."
  exit 1
fi

echo "Found VPC ID: $VPC_ID"

# Get the list of instance IDs in the specified VPC
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=vpc-id,Values=$VPC_ID" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Loop through each instance ID and modify instance metadata options
for INSTANCE_ID in $INSTANCE_IDS; do
  echo "Modifying instance metadata options for instance ID: $INSTANCE_ID"
  aws ec2 modify-instance-metadata-options --instance-id "$INSTANCE_ID" --http-tokens optional 
done

echo "Modification of instance metadata options complete."