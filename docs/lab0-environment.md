# Lab 0 - Set up your environment

## Preparing your account

Accounts using this workshop should have an IAM role configured with a specific set of IAM policies.  You can create such a role using [this provided JSON file](../labs/lab0/BirdWorkshopPolicy.json).

In addition, you should create a CloudFormation stack using [the CloudFormation template provided](../labs/lab0/BirdWorkshop.yaml).  It has a required parameter identifying publicly accessible URL to a zip file.  The zip file should contain four folders, each containing images for four specific bird species (0752, 0772, 0794, and 0842), extracted from the NABirds full dataset.  To get the full NABirds dataset, [go here](http://dl.allaboutbirds.org/nabirds).

## Preparing your workstation

The workshop is designed to be run entirely via the AWS console and an Amazon SageMaker notebook.  If instead you would like to do the work from your workstation directly, here are some additional requirements.

### Cloning the github repository

`github clone https://github.com/markproy/bird-classification-workshop`

This will provide all of the content you need to get started with the labs.

OR

Create a SageMaker notebook instance with ml.m4.xlarge instance type.

When it is created, Open it.  Click on New conda_python3.

In the first cell, paste this command and execute it (shift enter):

```
! git clone https://fbfd8b1f0692e5f155c19117204f0f9a7723c22b@github.com/markproy/bird-classification-workshop
```

Upload the `sample_images.zip` file to the `bird-classification-workshop` folder.  It is 91MB, and will take several minutes to upload.

Navigate on the Files tab to open the Jupyter notebook in `bird-classification-workshop/LabNotebook.ipynb`.

### Preparing the AWS CLI (command line interface)

If you have not yet set up your environment to use the AWS CLI, follow [these](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) instructions to install the CLI.  Step by step instructions for configuring the AWS CLI can be found [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).

### Installing Python

If you do not already have Python set up in your environment, you can download and install Python [here](https://www.python.org/downloads/).

### Installing additional Python packages

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
