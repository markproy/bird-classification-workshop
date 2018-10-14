# bird-classification-workshop

### Introduction
Machine learning is a game-changing technology with vast potential in every industry, yet many teams struggle with how to get started. In this “train the trainer” workshop, we share a sample project you can use with your customers and internal teams to have fun while diving deep on deep learning. You will get hands-on experience using Amazon SageMaker to build and deploy a neural network based on a publicly available dataset of 48,000 bird images.

You will also create a custom project for AWS DeepLens that detects birds and triggers species identification. By the end of the workshop, you will have a working end-to-end solution. Prerequisites: hands-on experience with Python, AWS Lambda, Amazon SNS, and Amazon S3 are required to get the most value from the workshop.

### Lab overview

The workshop is composed of the following 6 labs:

* [Lab 1](docs/lab1-image-prep.md) - Prepare images for training
* [Lab 2](docs/lab2-train-model.md) - Train the classification model using Amazon SageMaker
* [Lab 3](docs/lab3-host-model.md) - Host the trained model and identify your first bird!
* [Lab 4](docs/lab4-trigger-inference-from-s3.md) - Trigger an inference as new pictures arrive in S3
* [Lab 5](docs/lab5-deeplens-detect-and-classify.md) - Use AWS DeepLens to detect birds and trigger classification
* [Lab 6](docs/lab6-text-notification.md) - Configure SMS text notification with identified species (optional)

### Prerequisites

If you are setting up this workshop for others, or if you are executing this workshop in your own AWS account (versus attending a workshop at which you are given access to a temporary AWS account that is pre-configured), read [these instructions](docs/lab0-environment.md).

### Cleaning up

After you are done, it is important to clean up resources in your account so that you will not be billed unexpectedly.  If you used an AWS account that was supplied to you just for the purposes of this workshop, then you can skip this step.

* Delete the SageMaker endpoint
* Stop the SageMaker notebook instance
* Delete SageMaker notebook instance
* Delete any S3 buckets that you created just for this workshop
* Delete the DeepLens project you created
* Delete the SNS topic you created
* Delete the Lambda functions you created

### Acknowledgement for use of the NABirds dataset

**Data provided by the Cornell Lab of Ornithology, with thanks to photographers and contributors of crowdsourced data at AllAboutBirds.org/Labs.**

**This material is based upon work supported by the National Science Foundation under Grant No. 1010818.**

**Any requests for further use of this data should be directed** [here](http://dl.allaboutbirds.org/nabirds).
