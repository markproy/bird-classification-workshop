#!/bin/sh

# notebook instances should be cleaned up by simply deleting the CloudFormation stack, but just in case
echo Removing workshop specific SageMaker notebook instances...
aws sagemaker list-notebook-instances --name-contains ''BirdClassificationWorkshop0'' \
  --query "NotebookInstances[*].NotebookInstanceName" --output text | \
  xargs -I{} aws sagemaker delete-notebook-instance --notebook-instance-name {}
aws sagemaker list-notebook-instances --name-contains ''BirdClassificationWorkshop1'' \
  --query "NotebookInstances[*].NotebookInstanceName" --output text | \
  xargs -I{} aws sagemaker delete-notebook-instance --notebook-instance-name {}

# models, endpoint configs, and endpoints are all created on the fly in the workshop
# delete all of these, so we leave a clean environment
echo Removing workshop specific SageMaker models...
aws sagemaker list-models --name-contains ''birds-0'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-model --model-name {}
aws sagemaker list-models --name-contains ''birds-1'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-model --model-name {}

echo Removing workshop specific SageMaker endpoint configs...
aws sagemaker list-endpoint-configs --name-contains ''birds-0'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-endpoint-config --endpoint-config-name {}
aws sagemaker list-endpoint-configs --name-contains ''birds-1'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-endpoint-config --endpoint-config-name {}

echo Removing workshop specific SageMaker endpoints...
aws sagemaker list-endpoints --name-contains ''nabirds-species-identifier-'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-endpoint --endpoint-name {}

# how can we delete sagemaker training jobs?

# lambda functions

# SNS topics and subscriptions

# DeepLens projects
