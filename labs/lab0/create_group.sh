#!/bin/bash

# This script creates an IAM group that will be home for a set of DeepLens
# workshop IAM users.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.

# ./create_group.sh account1
# ./create_group.sh account2
# ./create_group.sh account3
# ./create_group.sh account4
# ./create_group.sh account5
# ./create_group.sh account6
# ./create_group.sh account7
# ./create_group.sh account8

Profile=$1
GroupName=deeplens-group

echo $Profile

echo Creating an IAM policy for all workshop users, and a group with that policy...
set -x

# used to create a policy from JSON, now instead just adding all the
# managed policies.

#aws iam create-policy --profile ${Profile} --policy-name deeplens-user-policy \
#  --policy-document file://BirdWorkshopPolicy.json

aws iam create-group --profile ${Profile} --group-name ${GroupName}

aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AWSLambdaFullAccess
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchFullAccess
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AWSDeepLensLambdaFunctionAccessPolicy
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccesswithDataPipeline
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSDeepLensServiceRolePolicy
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AWSIoTFullAccess
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AWSGreengrassFullAccess
aws iam --profile ${Profile} attach-group-policy --group-name deeplens-group \
  --policy-arn arn:aws:iam::aws:policy/AmazonSageMakerFullAccess

set +x
