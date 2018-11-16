#!/bin/bash

# This script iterates through all the BirdWorkshop sagemaker notebook instances,
# in this account, starting or stopping them all based on the first argument.  The
# second argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.

# ./notebooks_state.sh start deeplens-1
# ./notebooks_state.sh stop deeeplens-3

if [ $1 == "start" ]; then
   Command="start-notebook-instance"
   Selection="Stopped"
else
   Command="stop-notebook-instance"
   Selection="InService"
fi

Profile=$2

echo $Profile
echo $Command

set -x
aws sagemaker --profile ${Profile} --region us-east-1 list-notebook-instances \
  --status-equals ${Selection} --output text | cut -f 7 | \
  xargs -I{} aws sagemaker --profile ${Profile} --region us-east-1 $Command --notebook-instance-name {}

#--query "NotebookInstances[?NotebookInstanceStatus=='${Selection}'].NotebookInstanceName"
#BirdClassificationWorkshop02-01	BirdClassificationWorkshop01-08
#how do we turn the list of instances into one command for each selected instance?
