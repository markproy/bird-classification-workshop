#!/bin/bash

# This script cleans up after one re:Invent DeepLens workshop in preparation
# for the next.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.

# ./workshop_transition account1 us-east-1
# ./workshop_transition account2 us-east-1
# ./workshop_transition account3 us-east-1
# ./workshop_transition account4 us-east-1
# ./workshop_transition account5 us-east-1
# ./workshop_transition account6 us-east-1
# ./workshop_transition account7 us-east-1
# ./workshop_transition account8 us-east-1

if [ $# -lt 2 ]
then
  echo Pass the aws profile name and region, as in: ./workshop_transition.sh deeplens-1 us-east-1
  exit 1
fi

Profile=$1
Region=$2

echo $Profile
set -x

echo -e "\nRemoving S3 buckets..."
#  each account has the following S3 buckets that should not be deleted. they are used for
#  security / auditing purposes:
#    cloudtrail-awslogs-XXXXX-YYYY-isengard-do-not-delete
#    do-not-delete-gategarden-audit-XXXXX
aws --profile ${Profile} --region ${Region} s3 ls | cut -d" " -f 3 | \
  grep -v do-not-delete | xargs -I{} \
  aws --profile ${Profile} --region ${Region} s3 rb s3://{} --force


echo -e "\nRemoving all SageMaker notebook instances except ones for the Bird workshop..."
# need to 'cut -f 7' when some notebooks have lifecycle configurations instead of 'cut -f 6'.
aws --profile ${Profile} --region ${Region} \
  sagemaker list-notebook-instances --output text | cut -f 7 | \
  grep -v BirdClassificationWorkshop | xargs -I{} \
  aws --profile ${Profile} --region ${Region} \
    sagemaker delete-notebook-instance --notebook-instance-name {}



echo -e "\nRemoving SageMaker models, endpoints, and endpoint configurations"
aws --profile ${Profile} --region ${Region} sagemaker list-models --output text | \
  cut -f 4 | xargs -I{} \
  aws --profile ${Profile} --region ${Region} sagemaker delete-model --model-name {}

aws --profile ${Profile} --region ${Region} sagemaker list-endpoints --output text | \
  cut -f 4 | xargs -I{} \
  aws --profile ${Profile} --region ${Region} sagemaker delete-endpoint --endpoint-name {}

aws --profile ${Profile} --region ${Region} sagemaker list-endpoint-configs --output text | \
  cut -f 4 | xargs -I{} \
  aws --profile ${Profile} --region ${Region} sagemaker delete-endpoint-config --endpoint-config-name {}


echo -e "\nRemoving DynamoDB tables..."
aws --profile ${Profile} --region ${Region} dynamodb list-tables --output text | \
  cut -f 2 | xargs -I{} \
  aws --profile ${Profile} --region ${Region} dynamodb delete-table --table-name {}


echo -e "\nRemoving Lambda functions..."
aws --profile ${Profile} --region ${Region} lambda list-functions --output text | \
  cut -f 5 | xargs -I{} \
  aws --profile ${Profile} --region ${Region} lambda delete-function --function-name {}


echo -e "\nRemoving CloudWatch dashboards..."
aws --profile ${Profile} --region ${Region} cloudwatch list-dashboards --output text | \
  cut -f 3 | xargs -I{} \
  aws --profile ${Profile} --region ${Region} cloudwatch delete-dashboards --dashboard-names {}
