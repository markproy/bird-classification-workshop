# Lab 1 - Prepare images for training

In this lab, you will prepare the images dataset for training.  We will be using [SageMaker's Image Classification algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html).  It provides a supervised learning algorithm, taking an image as input and classifying it into one of many output categories.  The algorithm uses a convolutional neural network (ResNet), and is best trained with a dataset of images packaged in [Apache MXNet RecordIO](https://mxnet.incubator.apache.org/architecture/note_data_loading.html) format.

These are the high level steps you will take for the lab:

1. Download the images
2. Explore the dataset using a SageMaker notebook
3. Use the im2rec utility to package the images
4. Create an S3 bucket that will be used throughout the workshop (needs "DeepLens" prefix?)
5. Upload the packaged images to S3 for training

The following sections walk you through the detailed steps.

## Download the images

This workshop leverages the [NABirds]( http://dl.allaboutbirds.org/nabirds) dataset, which is provided by the [Cornell Lab of Ornithology](http://merlin.allaboutbirds.org/the-story/) whose mission is to help people answer the question "What is that bird?"  The licensing agreement does not permit us to distribute their dataset.  Instead, your instructor will provide a temporary link to use a subset of bird species during this workshop.

The full dataset contains nearly 50,000 images and the compressed download file is around 9 GB.  In addition to a long download time, it takes many hours to train a neural network on a dataset of this size.  To work with the full dataset, you can go [here](http://dl.allaboutbirds.org/nabirds) to register to download it yourself for non-commercial research purposes.

Use the instructor-provided URL to download 'sample_images.zip', saving it to the root directory of the workshop file structure.  This zip file contains bird images for a subset of species that will be used for the workshop.  Extract the zip file into the 'images' directory at the root of the workshop file structure.



## Explore the dataset

Open provided Jupyter notebook to look at counts of each species.  Look at image sizes.  Preview sample images from each species.  Look at species class id's and species names.

## Package the images

Run script that invokes im2rec to create packaged recordIO files.

## Upload the packaged images to S3

Create an S3 bucket - 'deeplens-sagemaker-20181128-test1'

Create a 'train' folder for the train.rec, and a 'validation' folder for the val.rec file.

Use 'aws s3 cp ...' or multi-part upload from Python script or from s3 console.
