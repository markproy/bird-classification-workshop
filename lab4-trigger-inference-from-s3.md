# Lab 4 - Trigger inference as new pictures arrive in s3

In this lab, you will configure your s3 bucket to automatically trigger an inference on your endpoint using images as they arrive in the bucket.  Here are the steps involved:

1. Create a Lambda function to identify bird species
2. Extend the function to publish to SNS
3. Configure your s3 bucket to trigger your Lambda function
4. Test by adding an image to s3

## Create a Lambda function

### Create the IAM role for Lambda function

Requires a role with access for Lambda to SNS, S3, and SageMaker.  The console doesn't let you pick SageMaker, so it has to be attached manually after the role gets created.  Else, could be included in the CFT that gets applied to each account for the workshop, or could be an add-on CFT that each attendee applies.

### Create a 'hello world' function

Use the Lambda console and pick the 'hello-world-python3' blueprint.  Name it 'IdentifySpeciesAndNotify'.  For IAM role, pick 'Choose an existing role' and then pick 'abc' which was created for you in the lab setup steps.  OR, create the IAM role in the previous step.

Add 'SAGEMAKER_ENDPOINT_NAME' environment variable 'nabirds-species-identifier'.

Add 'SNS_TOPIC_ARN' environment variable in later lab.

### In the Lambda Designer, add S3 as a Trigger

Select S3 in the left hand panel list of possible triggers.  Configure the trigger in the lower panel of the Designer console.

Select 'ObjectCreate(All)', with a 'Prefix' of 'birds/' and a 'Suffix' of '.jpg'.

Click 'Save'.

### Adding numpy support for a Lambda function

### Updating the Lambda function

Use script from Mac or Windows environment to create a Lambda function package and use the AWS CLI to update the function.

Windows deploy_lambda

Mac source ./deploy_lambda.sh

## Test by adding an image to s3

Copy a test image to s3.  Use console to upload, or use the AWS CLI.

aws s3 cp test_images/card.jpg s3://bucket/birds/card.jpg

You may have to refresh the console to see the new file in your bucket.

### Review CloudWatch logs for the Lambda function

Go to the Lambda console.  Click the 'Monitoring' tab.  You should see Invocations count go up.  Click 'View logs in CloudWatch'.  Click on the logstream.  
