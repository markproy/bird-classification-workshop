#!/bin/bash

# This script iterates through all the BirdWorkshop sagemaker notebook instances,
# in this account, starting or stopping them all based on the first argument.  The
# second argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.

# ./notebooks_state start default
# ./notebooks_state stop default

if [ $1 == "start" ]; then
   Command="start-notebook-instance"
else
   Command="stop-notebook-instance"
fi

Profile=$2

echo $Profile
echo $Command
set -x

aws sagemaker --profile ${Profile} --region us-east-1 list-notebook-instances \
  --name-contains ''BirdClassificationWorkshop'' \
  --output text | cut -f 7 | \
  xargs -I{} aws sagemaker $Command --notebook-instance-name {}

#  --query "NotebookInstances[*].NotebookInstanceName" \
