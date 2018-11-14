#!/bin/bash

# This script creates a set of CloudFormation stacks.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# The second argument is the workshop Pod number.  At reInvent, there are 15 pods
# in a room, with each pod containing 8 stations.

# ./create_stacks.sh account1 01
# ./create_stacks.sh account1 02
# ./create_stacks.sh account2 03
# ./create_stacks.sh account2 04
# ...
# ./create_stacks.sh account7 13
# ./create_stacks.sh account7 14
# ./create_stacks.sh account8 15

Profile=$1
Pod=$2

echo $Profile

echo Creating a set of 8 stacks for the pod ${Pod}...

let Seat=0
while [ $Seat -lt 8 ]
do
  let Seat=$Seat+1
  UserSuffix=${Pod}-"0${Seat}"
  echo $UserSuffix

  UserName=user-${UserSuffix}
  set -x
  aws --profile ${Profile} --region us-east-1 \
    cloudformation create-stack --stack-name bw${UserSuffix} \
    --template-body file://BirdWorkshopPerUser.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameters ParameterKey=NotebookInstanceState,ParameterValue=Stopped \
      ParameterKey=UserSuffix,ParameterValue=${UserSuffix}
  set +x
done
