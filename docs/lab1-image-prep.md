# Lab 1 - Prepare images for training

In this lab, you will prepare the images for training.  We will be using SageMaker's [Image Classification algorithm](https://docs.aws.amazon.com/sagemaker/latest/dg/image-classification.html) against these images.  This algorithm performs supervised learning, taking an image as input and classifying it into one of many output categories.  In this workshop, the output categories are species of birds like Cardinal and Goldfinch.  The algorithm uses a convolutional neural network called ResNet, and is best trained with a dataset of images packaged in [Apache MXNet RecordIO](https://mxnet.incubator.apache.org/architecture/note_data_loading.html) format.  

These are the high level steps you will take for Lab 1.  You will complete Steps 2 through 4 using a SageMaker notebook:

1. Create an S3 bucket for use throughout the workshop
2. Explore the dataset of bird images
3. Use the [im2rec](https://mxnet.incubator.apache.org/faq/recordio.html) utility to package the images
4. Upload the packaged images to S3 for training

## Step 1 - Create an S3 bucket for use throughout the workshop

You will need an S3 bucket throughout the workshop.  It will be used for:

* Providing the training and validation images to SageMaker
* Holding the model artifacts produced by SageMaker training jobs
* Storing cropped images of birds detected by DeepLens
* Triggering a Lambda function for identifying a bird species

To create the S3 bucket, first navigate to the [S3 console](https://console.aws.amazon.com/s3/home?region=us-east-1) and select `+ Create bucket`.

Name the bucket with a prefix of `deeplens-sagemaker-`.  To ensure uniqueness, add on a date formatted as `yyyy-mm-dd`, and then add your name.  For example, your bucket name could be `deeplens-sagemaker-20181126-roymark`.  Under `Region`, select `US East (N. Virginia)` to align with the notebook region.  Select `Create` in the bottom left corner to create the bucket.

You will use this S3 bucket name in multiple labs, including the very next step of this lab.  In that step, you will reference the bucket name in the first cell of your SageMaker notebook.

## Step 2 through 4 - Explore the dataset, Package images, Upload images

Prior to the workshop, a SageMaker notebook instance called `BirdClassificationWorkshop` was created in your account.  Open the [Amazon SageMaker console](https://console.aws.amazon.com/sagemaker/) and click on `Notebook instances` in the left hand panel.  If the `Status` of the instance is `InService`, click on `Open` to open the notebook instance.  If not, click on `Start` to first start the instance before opening it.

Once you have opened the instance, open the Jupyter notebook called `LabNotebook.ipynb` in the `bird-classification-workshop` folder in the `Files` tab of the instance.

Follow the instructions in the notebook to complete this step and steps 3 and 4.

## Acknowledgement to Cornell Lab of Ornithology for the NABirds images

This workshop leverages the [NABirds]( http://dl.allaboutbirds.org/nabirds) dataset, which is provided by the [Cornell Lab of Ornithology](http://merlin.allaboutbirds.org/the-story/) whose mission is to help people answer the question "What is that bird?"  The licensing agreement does not permit us to distribute their dataset.  Instead, your instructor will provide a temporary link to use a subset of bird species during this workshop.

The full dataset contains nearly 50,000 images, and the compressed download file is around 9 GB.  In addition to a long download time, training a neural network using a dataset of this size would take many hours.  That is not feasible in a 2-hour workshop.  If you would like to work with the full dataset later on to continue your learning, you can go [here](http://dl.allaboutbirds.org/nabirds) to register to download it yourself for non-commercial research purposes.

## Package the images (move this pic to the notebook)

The following figure illustrates the process of packaging the images.

![](./screenshots/prepare_images.png)

For this workshop, we have provided a script to do the packaging.  The script invokes the `im2rec` utility to create packaged RecordIO files.  You will perform this in the SageMaker notebook.

## Navigation

Go to the [Next Lab](lab2-train-model.md)

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
