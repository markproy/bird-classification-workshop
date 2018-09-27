# Lab 4 - Trigger inference as new pictures arrive in s3

In this lab, you will configure your s3 bucket to automatically trigger an inference on your endpoint using images as they arrive in the bucket.  Here are the steps involved:

1. Create a Lambda function to identify a bird
2. Extend the function to publish to SNS
3. Configure your s3 bucket to trigger your Lambda function
4. Test by adding an image to s3

## Create a Lambda function

### Create a 'hello world' function

Use the Lambda console and pick the 'hello world' blueprint.

### IAM role for Lambda function

Requires a role with access for Lambda to SNS, S3, and SageMaker.  The console doesn't let you pick SageMaker, so it has to be attached manually after the role gets created.  Else, could be included in the CFT that gets applied to each account for the workshop, or could be an add-on CFT that each attendee applies.

### Adding numpy support for a Lambda function

### Updating the Lambda function

Use script from Mac or Windows environment to create a Lambda function package and use the AWS CLI to update the function.

## Extend the function to publish to SNS

## Configure s3 to trigger your Lambda function

## Test by adding an image to s3
