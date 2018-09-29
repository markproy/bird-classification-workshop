# Lab 1 - Prepare images for training

In this lab, you will prepare the images for training.  We will be using SageMaker's [Image Classification algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html).  It provides a supervised learning algorithm, taking an image as input and classifying it into one of many output categories.  In this workshop, the output categories are species of birds like Cardinal and Oriole.  The algorithm uses a convolutional neural network (ResNet), and is best trained with a dataset of images packaged in [Apache MXNet RecordIO](https://mxnet.incubator.apache.org/architecture/note_data_loading.html) format.

These are the high level steps you will take for the lab:

1. Download the images
2. Explore the dataset using a SageMaker notebook
3. Use the [im2rec](https://mxnet.incubator.apache.org/faq/recordio.html) utility to package the images
4. Create an S3 bucket that will be used throughout the workshop
5. Upload the packaged images to S3 for training

The following sections walk you through the detailed steps.

## Download the images

### About the NABirds images

This workshop leverages the [NABirds]( http://dl.allaboutbirds.org/nabirds) dataset, which is provided by the [Cornell Lab of Ornithology](http://merlin.allaboutbirds.org/the-story/) whose mission is to help people answer the question "What is that bird?"  The licensing agreement does not permit us to distribute their dataset.  Instead, your instructor will provide a temporary link to use a subset of bird species during this workshop.

The full dataset contains nearly 50,000 images, and the compressed download file is around 9 GB.  In addition to a long download time, using a dataset of this size would take many hours to train a neural network.  That is not practical in a 2-hour workshop.  If you would like to work with the full dataset later on to continue your learning, you can go [here](http://dl.allaboutbirds.org/nabirds) to register to download it yourself for non-commercial research purposes.

### Download the images for the workshop

For the workshop, use the instructor-provided URL to download `sample_images.zip`, saving it to the root directory of the workshop file structure.  This zip file contains bird images for a subset of species that will be used for the workshop.  Extract the zip file into the `images` directory at the root of the workshop file structure.  This directory is provided as empty in the initial repository.

If you prefer to run a script after downloading the zip file to the root directory, use the following command from the `lab1` directory.

On Windows: `unzip_images.bat`

On Mac: `source unzip_images.sh`

## Explore the dataset

Open the SageMaker notebook to review the following:

* counts of images for each species
* distribution of image sizes
* sample images from each species
* species class id's and species names

## Package the images

Run script that invokes `im2rec` to create packaged RecordIO files.

## Upload the packaged images to S3

Create an S3 bucket - `deeplens-sagemaker-20181128-test1`.

Create a `train` folder for the `train.rec`, and a `validation` folder for the `val.rec` file.

Use `aws s3 cp ...` or multi-part upload from Python script or from s3 console.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
