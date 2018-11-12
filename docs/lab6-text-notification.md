# Lab 6 - Configure SMS text notification

In this lab, you will configure automatic SMS text notification whenever a bird species identification message is published on SNS.  Instead of looking up results in CloudWatch, you will immediately get them as a text on your cell phone.  Here are the steps:

1. Create an SNS topic
2. Configure a new subscription to your SNS topic
3. Test that bird species identification texts are sent to your phone
4. Extend the Lambda function to send a message to your new SNS topic

## Create an SNS topic

* Go to the [Amazon SNS console](https://console.aws.amazon.com/sns) on AWS.  
* Click on `Create topic`.
* Use the following topic name: `deeplens-sagemaker-birdpic-arrived` plus your suffix.
* Use `birds` as the display name.  The display name will show up as a prefix to your text.
* Click `Create topic`.

## Configure new SNS subscription

* Under the `Subscriptions` section of the topic details, click `Create subscription` to begin creating the subscription.
* Pick `SMS` as the protocol.
* For the `Endpoint`, enter your cell phone number (e.g., `+16035551212`).
* Click `Create subscription` to complete the process.

## Test the subscription

Before configuring the Lambda function and testing the end to end process, first be sure that the SNS subscription works.  Publish a simple message and see if you receive the text.

* On your `Topic details` page for your topic, click on `Publish to topic`.
* Your `Topic ARN` will be filled in automatically.
* Enter a simple `Subject` like `Hello world`.
* Enter a simple `Message` like `Machine learning is fun!` with `Raw` selected as the `Message format`.
* At the bottom of the page, click on `Publish message`.
* You should see a text message arrive on your cell phone.

Before extending the Lambda function, you will need to copy the ARN of your SNS topic.  You will be adding it as an environment variable to your function.

## Extend the Lambda function to publish to SNS

In [Lab 4](lab4-trigger-inference-from-s3.md), you created a Lambda function called `IdentifySpeciesAndNotify` plus your suffix.  It already has code that attempts to publish the species identification message to SNS:

```
mySNSTopicARN = os.environ['SNS_TOPIC_ARN']
response = sns.publish(TopicArn=mySNSTopicARN, Message=msg)
```

Now we will enable that code to work by providing a functioning SNS topic.

* Copy the SNS topic ARN.  You will be pasting it into an environment variable shortly.
* Go to the [Lambda console](https://console.aws.amazon.com/lambda/) on AWS.
* On the Lambda console, click on `Functions` in the left hand panel, and navigate to the `IdentifySpeciesAndNotify` (plus your suffix) function (not the DeepLens object detection function) by clicking on that function name.
* Scroll down to the `Environment variables` section.
* Add `SNS_TOPIC_ARN` as a new key, and paste in the ARN of your SNS topic as the value.
* Click `Save` to record the updated variables.
* On the `Actions` menu, click `Publish new version`. Note the new version number.  Add a comment. Click `Publish`.

## Test

You can test out the notification by simply having the DeepLens detect another bird.  You should receive a text message with the species identification and confidence level.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
