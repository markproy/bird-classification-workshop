#!/bin/sh
JOB_NAME=$1
SUFFIX=$2

# Extract 2 parameters from the training job description:
#   1. the S3 URI for the model artifacts ("ModelArtifacts.S3ModelArtifacts")
#   2. the ARN for the IAM role ("RoleArn")
EXECUTION_ROLE_ARN=$(aws sagemaker describe-training-job --training-job-name $1 \
  --query "RoleArn" --output text)
echo role is $EXECUTION_ROLE_ARN
MODEL_DATA_URL=$(aws sagemaker describe-training-job --training-job-name $1 \
  --query "ModelArtifacts.S3ModelArtifacts" --output text)
echo model data url is $MODEL_DATA_URL

MODEL_NAME='birds-'$SUFFIX
ENDPOINT_CONFIG_NAME=$MODEL_NAME
INSTANCE_TYPE='ml.t2.medium' # 0.065/hr, or ml.m5.large=$0.13/hr, or m5.xlarge=$0.269/hr
ENDPOINT_NAME='nabirds-species-identifier-'$SUFFIX
PRODUCTION_VARIANTS=[{\"VariantName\":\"main\",\"ModelName\":\"$MODEL_NAME\",\"InitialInstanceCount\":1,\"InstanceType\":\"$INSTANCE_TYPE\",\"InitialVariantWeight\":1.0}]

IMAGE='811284229777.dkr.ecr.us-east-1.amazonaws.com/image-classification:latest'

PRIMARY_CONTAINER={\"Image\":\"$IMAGE\",\"ModelDataUrl\":\"$MODEL_DATA_URL\"}

echo Creating SageMaker model from artifacts produced by training job...
aws sagemaker delete-model --model-name ''$MODEL_NAME'' 2>/dev/null
aws sagemaker create-model --model-name ''$MODEL_NAME'' \
	--execution-role-arn ''$EXECUTION_ROLE_ARN'' \
	--primary-container ''$PRIMARY_CONTAINER''

echo Creating SageMaker endpoint config from model...
aws sagemaker delete-endpoint-config --endpoint-config-name ''$ENDPOINT_CONFIG_NAME'' 2>/dev/null
aws sagemaker create-endpoint-config --endpoint-config-name ''$ENDPOINT_CONFIG_NAME'' \
  	--production-variants ''$PRODUCTION_VARIANTS''

echo Creating endpoint from endpoint config...
aws sagemaker delete-endpoint --endpoint-name ''$ENDPOINT_NAME'' 2>/dev/null
# wait for the endpoint to go away before replacing it
sleep 1
# now create the new one
aws sagemaker create-endpoint --endpoint-name ''$ENDPOINT_NAME'' --endpoint-config-name ''$ENDPOINT_CONFIG_NAME''
