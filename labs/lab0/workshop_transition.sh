#!/bin/bash

# This script cleans up after one re:Invent DeepLens workshop in preparation
# for the next.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.

# ./workshop_transition account1
# ./workshop_transition account2
# ./workshop_transition account3
# ./workshop_transition account4
# ./workshop_transition account5
# ./workshop_transition account6
# ./workshop_transition account7
# ./workshop_transition account8

if [ $# -eq 0 ]
then
  echo Pass the aws profile name, as in: ./workshop_transition.sh deeplens-1
  exit 1
fi

Profile=$1
echo $Profile
set -x

echo -e "\nRemoving S3 buckets [change to not delete those marked do-not-delete]..."
aws --profile ${Profile} --region us-east-1 s3 ls | cut -d" " -f 3 | xargs -I{} \
  echo removing {} with --profile ${Profile}


echo -e "\nRemoving all SageMaker notebook instances except ones for the Bird workshop..."
# need to 'cut -f 7' when some notebooks have lifecycle configurations instead of 'cut -f 6'.
aws --profile ${Profile} --region us-east-1 \
  sagemaker list-notebook-instances --output text | cut -f 7 | xargs -I{} \
  ./delete_if_not_bird.sh ${Profile} {}
#  aws sagemaker delete-notebook-instance --notebook-instance-name {}



echo -e "\nRemoving SageMaker models, endpoints, and endpoint configurations"
aws --profile ${Profile} --region us-east-1 sagemaker list-models --output text | \
  cut -f 4 | xargs -I{} \
  aws --profile ${Profile} --region us-east-1 sagemaker delete-model --model-name {}

aws --profile ${Profile} --region us-east-1 sagemaker list-endpoints --output text | \
  cut -f 4 | xargs -I{} \
  aws --profile ${Profile} --region us-east-1 sagemaker delete-endpoint --endpoint-name {}

aws --profile ${Profile} --region us-east-1 sagemaker list-endpoint-configs --output text | \
  cut -f 4 | xargs -I{} \
  aws --profile ${Profile} --region us-east-1 sagemaker delete-endpoint-config --endpoint-config-name {}


echo -e "\nRemoving DynamoDB tables..."
aws --profile ${Profile} --region us-east-1 dynamodb list-tables --output text | \
  cut -f 2 | xargs -I{} \
  aws --profile ${Profile} --region us-east-1 dynamodb delete-table --table-name {}


echo -e "\nRemoving Lambda functions..."
aws --profile ${Profile} --region us-east-1 lambda list-functions --output text | \
  cut -f 5 | xargs -I{} \
  aws --profile ${Profile} --region us-east-1 lambda delete-function --function-name {}


echo -e "\nRemoving CloudWatch dashboards..."
aws --profile ${Profile} --region us-east-1 cloudwatch list-dashboards --output text | \
  cut -f 3 | xargs -I{} \
  aws --profile ${Profile} --region us-east-1 cloudwatch delete-dashboards --dashboard-names {}
