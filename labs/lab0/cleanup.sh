#!/bin/sh
aws sagemaker list-notebook-instances --name-contains ''BirdClassificationWorkshop0'' --output text | cut -f 6 | xargs -I{} aws sagemaker delete-notebook-instance --notebook-instance-name {}
aws sagemaker list-notebook-instances --name-contains ''BirdClassificationWorkshop1'' --output text | cut -f 6 | xargs -I{} aws sagemaker delete-notebook-instance --notebook-instance-name {}

aws sagemaker list-models --name-contains ''birds-0'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-model --model-name {}
aws sagemaker list-models --name-contains ''birds-1'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-model --model-name {}

aws sagemaker list-endpoint-configs --name-contains ''birds-0'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-endpoint-config --endpoint-config-name {}
aws sagemaker list-endpoint-configs --name-contains ''birds-1'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-endpoint-config --endpoint-config-name {}

aws sagemaker list-endpoints --name-contains ''nabirds-species-identifier-'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-endpoint --endpoint-name {}

# lambda functions
# SNS topics and subscriptions
