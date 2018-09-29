# Lab 4 - Trigger inference as new pictures arrive in s3

In this lab, you will configure your s3 bucket to automatically trigger an inference on your endpoint using images as they arrive in the bucket.  Here are the steps involved:

1. Create a Lambda function to identify bird species
2. Configure your s3 bucket to trigger your Lambda function
3. Test by adding an image to s3
4. Extend the function to publish to SNS

## Create a Lambda function

### Create the IAM role for Lambda function

Requires a role with access for Lambda to SNS, S3, and SageMaker.  The console doesn't let you pick SageMaker, so it has to be attached manually after the role gets created.  Else, could be included in the CFT that gets applied to each account for the workshop, or could be an add-on CFT that each attendee applies.

### Create a 'hello world' function

Use the Lambda console and pick the `hello-world-python3` blueprint.  Name it `IdentifySpeciesAndNotify`.  For IAM role, pick `Choose an existing role` and then pick `abc` which was created for you in the lab setup steps.  OR, create the IAM role in the previous step.

### Update the code

The code for this lambda function is provided in `labs\lab4\lambda\lambda_function.py` .  When your Lambda function has an external dependency that is not provided in the default Lambda environment, you need to provide those external dependencies.  You provide those in a package, and the editing of the function cannot be done on the Lambda console.  Review the [function code](../labs/lab4/lambda/lambda_function.py).  Let's walk through a few key sections.

#### Invoking the SageMaker endpoint

In the following section of the code, we take the cropped image from S3 as an array of bytes and pass it as the payload to the SageMaker endpoint identified in the Lambda function environment variable.  The inference result comes back as an array of probabilities, each one corresponding to the likelihood that the image represents a bird of that species.

```
payload = s3_object_response['Body'].read()
endpoint_name = os.environ['SAGEMAKER_ENDPOINT_NAME']
endpoint_response = runtime.invoke_endpoint(
                            EndpointName=endpoint_name,
                            ContentType='application/x-image',
                            Body=payload)
result = endpoint_response['Body'].read()
```

#### Parse the results

Once we have the results of the inference, we turn it into a two-dimensional array with the index of the species and the probability that the image is of that species.  The array is sorted in descending probability, with the most likely species first.

```
result = json.loads(result)
indexes = np.empty(len(result))
for i in range(0, len(result)):
    indexes[i] = i
full_results = np.vstack((indexes, result))
transposed_full_results = full_results.T
sorted_transposed_results = transposed_full_results[transposed_full_results[:,1].argsort()[::-1]]
```

#### Create a human readable message with the results

Given the sorted results, it is straightforward to then construct a message that summarizes what the model predicted.  This can be logged or pushed to SNS (and on to SMS).  If the model is beyond a configurable threshold, the message definitively states the bird species.  Otherwise, it shows the confidence level of the top two species.  The S3 object key is included in the message to support viewing of the cropped image that was used as input.  A useful extension to this lab would be to provide a signed URL to the image as part of the message.

```
msg = ''
if (sorted_transposed_results[0][1] > CERTAINTY_THRESHOLD):
    msg = 'Bird [' + key + '] is a: ' + object_categories[int(sorted_transposed_results[0][0])] + '(' + \
            '{:2.2f}'.format(sorted_transposed_results[0][1]) + ')'
else:
    msg = 'Bird [' + key + '] may be a: '
    for top_index in range(0, TOP_K):
        if (top_index > 0):
            msg = msg + ', or '
        msg = msg + object_categories[int(sorted_transposed_results[top_index][0])] + '(' + \
                  '{:2.2f}'.format(sorted_transposed_results[top_index][1]) + ')'
```

#### Publishing the message to SNS

Two simple lines of code are all that we need to publish the message to SNS, and one of them is just retrieving the SNS topic ARN from a Lambda environment variable.

```
mySNSTopicARN = os.environ['SNS_TOPIC_ARN']
response = sns.publish(TopicArn=mySNSTopicARN, Message=msg)
```

### Add environment variables

Add `SAGEMAKER_ENDPOINT_NAME` environment variable `nabirds-species-identifier`.

Add `SNS_TOPIC_ARN` environment variable in later lab.

### In the Lambda Designer, add S3 as a Trigger

Select S3 in the left hand panel list of possible triggers.  Configure the trigger in the lower panel of the Designer console.

Select `ObjectCreate(All)`, with a `Prefix` of `birds/` and a `Suffix` of `.jpg`.

Click `Save`.

### Adding numpy support for a Lambda function

### Updating the Lambda function

Use script from Mac or Windows environment to create a Lambda function package and use the AWS CLI to update the function.

Windows `deploy_lambda`

Mac `source ./deploy_lambda.sh`

## Test by adding an image to s3

Copy a test image to s3.  Use console to upload, or use the AWS CLI.

`aws s3 cp test_images/card.jpg s3://bucket/birds/card.jpg`

You may have to refresh the console to see the new file in your bucket.

### Review CloudWatch logs for the Lambda function

Go to the Lambda console.  Click the `Monitoring` tab.  You should see Invocations count go up.  Click `View logs in CloudWatch`.  Click on the logstream.  Review the logs.  Look for ones with `msg` to see the results of the SageMaker inference.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
