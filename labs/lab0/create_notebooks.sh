#!/bin/bash

# This script creates a set of BirdWorkshop sagemaker notebook instances.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# The second argument is the workshop Pod number.  At reInvent, there are 15 pods
# in a room, with each pod containing 8 stations.

# ./create_notebooks account1 01 us-east-1
# ./create_notebooks account1 02 us-east-1
# ./create_notebooks account2 03 us-east-1
# ./create_notebooks account2 04 us-east-1
# ...
# ./create_notebooks account7 13 us-east-1
# ./create_notebooks account7 14 us-east-1
# ./create_notebooks account8 15 us-east-1

if [ $# -lt 3 ]
then
  echo Pass the aws profile name, Pod Number, and region, as in: ./create_stacks.sh deeplens-1 02 us-east-1
  exit 1
fi

Profile=$1
Pod=$2
Region=$3

echo $Profile
set -x

let Seat=0
while [ $Seat -lt 8 ]
do
  let Seat=$Seat+1
  UserSuffix=${Pod}-"0${Seat}"
  echo $UserSuffix

  aws --profile ${Profile} --region ${Region} \
    cloudformation create-stack --stack-name BW${UserSuffix} \
    --template-body file://"BirdWorkshopPerUser.yaml" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters ParameterKey=UserSuffix,ParameterValue=${UserSuffix}

done
