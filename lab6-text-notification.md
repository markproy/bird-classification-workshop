# Lab 6 - Configure SMS text notification

In this lab, you will configure automatic SMS text notification whenever a species identification message is published on SNS.  Here are the steps:

1. Create an SNA topic
2. Configure a new subscription to your SNS topic
3. Test

## Create an SNS topic

Call it `deeplens-sagemaker-birdpic-arrived`.

## Configure new SNS subscription

Click `Create subscription`.  Pick `SMS` as the protocol.  Enter your cell phone number (e.g., `+16035551212`).

## Extend the Lambda function to publish to SNS

Change the code.

Add the Lambda environment variable `SNS_TOPIC_ARN` to use the arn of the SNS topic.

## Test
