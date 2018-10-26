#!/bin/sh

# this script should be run in a terminal window inside your SageMaker notebook
# that was created as part of the workshop.

if [ $# -eq 0 ]
then
  echo Pass the S3 bucket name as in: bash shortcut.sh deeplens-sagemaker-20181126-smithjohn
  exit 1
fi

BUCKET_NAME=$1  # name of bucket you created, something like deeplens-sagemaker-20181126-smithjohn
TRAIN_RATIO=0.75
PREFIX=/birds

# install prerequisite packages
pip install mxnet
pip install opencv-python

# for some reason, boto3 can get errors with certain versions of the AWS CLI.
# To avoid hitting errors like 'serviceID not defined in the medata ...', we install
# a specific AWS CLI verion.
pip install awscli==1.16.9 awsebcli==3.14.4 --user

cd ~/SageMaker/bird-classification-workshop/labs/lab1

echo Generating .lst files.  This could take a minute...
python im2rec.py --list --recursive --train-ratio $TRAIN_RATIO nabirds_sample ../../images/

echo Here are the resulting files:
ls -l *.lst

echo Here are the last few lines of the validation list file:
tail *val.lst

echo Show the number of training images by counting lines in the list file.
more nabirds_sample_train.lst | wc -l

echo Generating packaged RecordIO files.  This could take a minute...
python im2rec.py --resize 256 nabirds_sample ../../images/

echo Here are the resulting files:
ls -l *.rec

echo Copying the packaged RecordIO files to S3...
aws s3 cp nabirds_sample_train.rec s3://$BUCKET_NAME$PREFIX/train/nabirds_sample_train.rec
aws s3 cp nabirds_sample_val.rec s3://$BUCKET_NAME$PREFIX/validation/nabirds_sample_val.rec

echo Here are the resulting files in S3:
aws s3 ls s3://$BUCKET_NAME$PREFIX/train/
aws s3 ls s3://$BUCKET_NAME$PREFIX/validation/
