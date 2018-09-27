# Lab 1 - Prepare images for training

In this lab, you will prepare the images dataset for training.  These are the steps you will take for the lab:

1. Download the images
2. Explore the dataset using a SageMaker notebook
3. Use the im2rec utility to package the images
4. Create an s3 bucket that will be used throughout the workshop (needs "DeepLens" prefix?)
5. Upload the packaged images to s3 for training

## Download the images

Use the bit.ly URL to download the sample bird images for 4 species.  This is the image dataset that will be used for the workshop.  Extract the zip file into the 'images' directory.

## Explore the dataset

Open provided Jupyter notebook to look at counts of each species.  Look at image sizes.  Preview sample images from each species.  Look at species class id's and species names.

## Package the images

Run script that invokes im2rec to create packaged recordIO files.

## Create an s3 bucket

'deeplens-sagemaker-20181128-test1'

## Upload the packaged images to s3

Use 'aws s3 cp ...' or multi-part upload from Python script or from s3 console.
