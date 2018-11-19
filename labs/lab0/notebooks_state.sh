#!/bin/bash
# This script iterates through all the SageMaker notebook instances,
# in all workshop accounts, starting or stopping them all based on the first argument.  The
# second argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# ./notebooks_state.sh start deeplens-1 us-east-1
# ./notebooks_state.sh stop deeplens-3 us-east-1

if [ $# -lt 3 ]; then
  echo Pass in state, account, and region, as in: ./notebooks_state.sh start deeplens-1 us-east-1
  exit 1
fi

if [ $1 == "start" ]; then
   Command="start-notebook-instance"
   Selection="Stopped"
else
   Command="stop-notebook-instance"
   Selection="InService"
fi

Profile=$2
Region=$3

echo $Profile
echo $Command

set -x
aws sagemaker --profile ${Profile} --region ${Region} list-notebook-instances \
  --status-equals ${Selection} --output text | cut -f 7 | \
  xargs -I{} aws sagemaker --profile ${Profile} --region ${Region} $Command --notebook-instance-name {}

#--query "NotebookInstances[?NotebookInstanceStatus=='${Selection}'].NotebookInstanceName"
#BirdClassificationWorkshop02-01	BirdClassificationWorkshop01-08
