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

`python test_direct_sample.py ../test_images/card.jpg`

This should invoke the SageMaker endpoint, parse the results, create and print a message telling you which bird species was identified.  If the confidence level was low, it will tell you the top 2 candidates.  Confidence levels are also printed.