# Lab 5 - Use AWS DeepLens to detect birds and trigger classification

In this lab, you will use AWS DeepLens to detect birds and trigger classification of the bird species.  Here are the steps:

1. Register the DeepLens device
2. Customize the object detection function
3. Create and deploy the bird detection project
4. Test the project

## Register the DeepLens device

Use documentation of standard steps.

## Customize the object detection function

## Create and deploy the bird detection project

Create new project.  Choose project type.  Object detection. Next. Create.

Select the project.  Deploy to device.  Pick the device you registered.  Review.  Deploy.

## Test the project

Login to the device using the keyboard and monitor.  "aws_cam" is the username.  "Aws2018!" is the password.

mplayer -demuxer lavf -lavfdopts format=mjpeg:probesize=32 /tmp/results.mjpeg
