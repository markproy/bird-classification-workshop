# bird-classification-workshop

### Introduction
Machine learning is a game-changing technology with vast potential in every industry, yet many teams struggle with how to get started. In this “train the trainer” workshop, we share a sample project you can use with your customers and internal teams to have fun while diving deep on deep learning. You will get hands-on experience using Amazon SageMaker to build and deploy a neural network based on a publicly available dataset of 48,000 bird images.

You will also create a custom project for AWS DeepLens that detects birds and triggers species identification. By the end of the workshop, you will have a working end-to-end solution. Prerequisites: hands-on experience with Python, AWS Lambda, Amazon SNS, and Amazon S3 are required to get the most value from the workshop.

### Getting started

In this workshop, you have an AWS DeepLens device in front of you connected to a monitor, keyboard, and mouse.  You can use the DeepLens device to run the entire workshop, or you can use your laptop to do all of the labs other than the DeepLens lab (lab 5).

#### Log into the AWS console

Once the browser is open, type `console.aws.amazon.com` into the url bar. (Note: If the login page says "Root user sign in" and there's already an email showing, select Sign in to a different account and then type in your AWS Account number on your card.)

Once your login page shows three fields, please enter the following:

* Account ID or alias: the AWS Account number on your card
* IAM user name: the User name on your card
* Password: `Aws2017!`

Next, make sure you're in N. Virginia region. Proceed to Lab 1.

#### If you are using DeepLens instead of your laptop

AWS DeepLens runs an Ubuntu OS. Login to the device with the password `Aws2017!` for the `aws_cam` username.

We have already pre-registered your DeepLens device to your workshop account. You can find the information for your account on the card in front of you taped to your monitor.

Open a Firefox browser on the left panel and follow the console login instructions.

### Lab overview

The workshop is composed of the following 6 labs:

* [Lab 1](docs/lab1-image-prep.md) - Prepare images for training
* [Lab 2](docs/lab2-train-model.md) - Train the classification model using Amazon SageMaker
* [Lab 3](docs/lab3-host-model.md) - Host the trained model and identify your first bird!
* [Lab 4](docs/lab4-trigger-inference-from-s3.md) - Trigger an inference as new pictures arrive in S3
* [Lab 5](docs/lab5-deeplens-detect-and-classify.md) - Use AWS DeepLens to detect birds and trigger species identification
* [Lab 6](docs/lab6-text-notification.md) - Configure SMS text notification with identified species (optional)

### Cleaning up

After you are done, it is important to clean up resources in your account so that you will not be billed unexpectedly.  If you used an AWS account that was supplied to you just for the purposes of this workshop, then you can skip this step.  Otherwise, take the following steps:

* Delete the SageMaker endpoint
* Stop the SageMaker notebook instance
* Delete SageMaker notebook instance
* Delete any objects you created in your S3 bucket
* Delete the S3 bucket that you created just for this workshop
* Delete the DeepLens project you created
* Delete the SNS topic you created
* Delete the Lambda functions you created

### Acknowledgement for use of the NABirds dataset

**Data provided by the Cornell Lab of Ornithology, with thanks to photographers and contributors of crowdsourced data at AllAboutBirds.org/Labs.**

**This material is based upon work supported by the National Science Foundation under Grant No. 1010818.**

**Any requests for further use of this data should be directed** [here](http://dl.allaboutbirds.org/nabirds).

### Additional setup if you are leading a workshop

If you are setting up this workshop for others, or if you are executing this workshop in your own AWS account (versus attending a workshop at which you are given access to a temporary AWS account that is pre-configured), read [these instructions](docs/lab0-environment.md).
