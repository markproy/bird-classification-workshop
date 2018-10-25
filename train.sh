#!/bin/sh

# Fill in the values of these four variables
arn_role=arn:aws:iam::355151823911:role/service-role/AmazonSageMaker-ExecutionRole-20180515T132694
training_image=811284229777.dkr.ecr.us-east-1.amazonaws.com/image-classification:1
bucket=s3://roymark-aws-ml
region=us-east-1

prefix=/birds-test
training_job_name=birds-`date '+%Y-%m-%d-%H-%M-%S'`

training_data=$bucket$prefix/train
val_data=$bucket$prefix/validation
train_source={S3DataSource={S3DataType=S3Prefix,S3DataDistributionType=FullyReplicated,S3Uri=$training_data}}
val_source={S3DataSource={S3DataType=S3Prefix,S3DataDistributionType=FullyReplicated,S3Uri=$val_data}}

aws --region $region \
sagemaker create-training-job \
--role-arn $arn_role \
--training-job-name $training_job_name \
--algorithm-specification TrainingImage=$training_image,TrainingInputMode=File \
--resource-config InstanceCount=1,InstanceType=ml.p3.2xlarge,VolumeSizeInGB=50 \
--input-data-config ChannelName=train,DataSource=$train_source,ContentType=application/x-recordio,CompressionType=None,RecordWrapperType=None ChannelName=validation,DataSource=$val_source,ContentType=application/x-recordio,CompressionType=None,RecordWrapperType=None \
--output-data-config S3OutputPath=$bucket$prefix \
--hyper-parameters \
      '{"augmentation_type": "crop", "beta_1": "0.9", "beta_2": "0.999", "checkpoint_frequency": "20", "epochs": "20", "eps": "1e-8", "gamma": "0.9", "image_shape": "3,224,224", "learning_rate": "0.1", "lr_scheduler_factor": "0.1", "mini_batch_size": "24", "momentum": "0.9", "multi_label": "0", "num_classes": "4", "num_layers": "152", "num_training_samples": "322", "optimizer": "sgd", "precision_dtype": "float32", "top_k": "2", "use_pretrained_model": "0", "use_weighted_loss": "0", "weight_decay": "0.0001" }' \
--stopping-condition MaxRuntimeInSeconds=1800

#augmentation_type=crop,beta_1=0.9,beta_2=0.999,checkpoint_frequency=20,\
#epochs=20,eps=1e-8,gamma=0.9,image_shape=3\,224\,224,learning_rate=0.1,lr_scheduler_factor=0.1,\
#mini_batch_size=24,momentum=0.9,multi_label=0,num_classes=4,num_layers=152,\
#num_training_samples=322,optimizer=sgd,precision_dtype=float32,top_k=2,\
#use_pretrained_model=0,use_weighted_loss=0,weight_decay=0.0001 \
#--stopping-condition MaxRuntimeInSeconds=1800
