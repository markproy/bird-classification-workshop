# Lab 0 - Setting up your environment

## Cloning the github repository

`github clone https://github.com/markproy/bird-classification-workshop`

This will provide all of the content you need to get started with the labs.

## Preparing the AWS CLI (command line interface)

If you have not yet set up your environment to use the AWS CLI, follow [these](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) instructions to install the CLI.  Step by step instructions for configuring the AWS CLI can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

## Installing Python

If you do not already have Python set up in your environment, you can download and install Python [here](https://www.python.org/downloads/).

## Installing additional Python packages

To complete all the labs, you will also need some additional Python libraries that can be installed using `pip` as follows:

```
python -m pip install —upgrade pip
pip install boto3
pip install numpy
pip install pandas
pip install mxnet
pip install opencv-python
```

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
