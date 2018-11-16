#!/bin/bash

# This script deletes a SageMaker notebook instance if it is not named BirdClassificationWorkshop*.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# The second argument is the name of a SageMaker notebook instance to possibly delete.

# ./delete_if_not_bird.sh deeplens-1 some-other-instance

if [ $# -lt 3 ]
then
  echo Pass the aws profile name and the instance name, as in: ./delete_if_not_bird.sh deeplens-1 some-notebook-name us-east-1
  exit 1
fi

Profile=$1
NotebookName=$2
Region=$3
set -x

if [[ ${NotebookName} == "BirdClassificationWorkshop"* ]];
then
  echo Not deleting ${NotebookName}
else
  echo Deleting ${NotebookName} ...
  aws --profile ${Profile} --region ${Region} \
    sagemaker delete-notebook-instance --notebook-instance-name ${NotebookName}
fi
