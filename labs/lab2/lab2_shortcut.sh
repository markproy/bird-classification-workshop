#!/bin/sh

# this script should be run in a terminal window inside your SageMaker notebook
# that was created as part of the workshop.

if [ $# -lt 2 ]
then
  echo Pass the bucket and the user suffix, as in:
  echo   bash lab2_shortcut.sh s3://deeplens-sagemaker-20181126-smithjohn 01
  exit 1
fi

# Fill in the values of these four variables
BUCKET=$1
INSTANCE_NAME=BirdClassificationWorkshop$2

EXECUTION_ROLE_ARN=$(aws sagemaker describe-notebook-instance \
  --notebook-instance-name $INSTANCE_NAME \
  --query "RoleArn" --output text)
echo role is $EXECUTION_ROLE_ARN

# arn_role=$2

REGION=us-east-1
TRAINING_IMAGE=811284229777.dkr.ecr.us-east-1.amazonaws.com/image-classification:1

PREFIX=/birds
TRAINING_JOB_NAME=birds-`date '+%Y-%m-%d-%H-%M-%S'`

TRAINING_DATA=$BUCKET$PREFIX/train
VAL_DATA=$BUCKET$PREFIX/validation
TRAIN_SOURCE={S3DataSource={S3DataType=S3Prefix,S3DataDistributionType=FullyReplicated,S3Uri=$TRAINING_DATA}}
VAL_SOURCE={S3DataSource={S3DataType=S3Prefix,S3DataDistributionType=FullyReplicated,S3Uri=$VAL_DATA}}

aws --region $REGION \
sagemaker create-training-job \
--role-arn $EXECUTION_ROLE_ARN \
--training-job-name $TRAINING_JOB_NAME \
--algorithm-specification TrainingImage=$TRAINING_IMAGE,TrainingInputMode=File \
--resource-config InstanceCount=1,InstanceType=ml.p3.2xlarge,VolumeSizeInGB=50 \
--input-data-config ChannelName=train,DataSource=$TRAIN_SOURCE,ContentType=application/x-recordio,CompressionType=None,RecordWrapperType=None ChannelName=validation,DataSource=$VAL_SOURCE,ContentType=application/x-recordio,CompressionType=None,RecordWrapperType=None \
--output-data-config S3OutputPath=$BUCKET$PREFIX \
--hyper-parameters \
      '{"augmentation_type": "crop", "beta_1": "0.9", "beta_2": "0.999", "checkpoint_frequency": "25", "epochs": "25", "eps": "1e-8", "gamma": "0.9", "image_shape": "3,224,224", "learning_rate": "0.1", "lr_scheduler_factor": "0.1", "mini_batch_size": "24", "momentum": "0.9", "multi_label": "0", "num_classes": "4", "num_layers": "152", "num_training_samples": "322", "optimizer": "sgd", "precision_dtype": "float32", "top_k": "2", "use_pretrained_model": "0", "use_weighted_loss": "0", "weight_decay": "0.0001" }' \
--stopping-condition MaxRuntimeInSeconds=1800
