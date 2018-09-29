# Lab 3 - Host the inference model and identify your first bird!

In this lab, you will host the inference model and identify your first bird!  Here are the steps:

1. Create a SageMaker model from the training artifacts
2. Create a SageMaker endpoint configuration
3. Create a SageMaker endpoint
4. Test your model using the endpoint

## Create a SageMaker model

inference image is: `811284229777.dkr.ecr.us-east-1.amazonaws.com/image-classification:1`

## Create a SageMaker endpoint configuration

## Create a SageMaker endpoint

## Test your model

Windows
`set ENDPOINT_NAME=nabirds-species-identifier`

Mac
`export ENDPOINT_NAME=nabirds-species-identifier`


`python test_direct_sample.py ../../test_images/card.jpg`

**should default the endpoint name so that no one needs to set an env var**

This will invoke the SageMaker endpoint, parse the results, create and print a message telling you which bird species was identified.  If the confidence level was low, it will tell you the top 2 candidates.  Confidence levels are also printed.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
