#!/bin/bash

# This script creates a set of BirdWorkshop sagemaker notebook instances.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# The second argument is the workshop Pod number.  At reInvent, there are 15 pods
# in a room, with each pod containing 8 stations.

# ./create_notebooks account1 01
# ./create_notebooks account1 02
# ./create_notebooks account2 03
# ./create_notebooks account2 04
# ...
# ./create_notebooks account7 13
# ./create_notebooks account7 14
# ./create_notebooks account8 15

Profile=$1
Pod=$2

echo $Profile
set -x

let Seat=0
while [ $Seat -lt 8 ]
do
  let Seat=$Seat+1
  UserSuffix=${Pod}-"0${Seat}"
  echo $UserSuffix

  aws --profile ${Profile} --region us-east-1 \
    cloudformation create-stack --stack-name BW${UserSuffix} \
    --template-body file://"BirdWorkshopPerUser.yaml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters ParameterKey=UserSuffix,ParameterValue=${UserSuffix}

done
