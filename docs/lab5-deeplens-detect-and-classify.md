# Lab 5 - Use AWS DeepLens to detect birds and trigger classification

In this lab, you will use AWS DeepLens to detect birds and trigger classification of the bird species.  Here are the steps:

1. Register the DeepLens device
2. Deploy off the shelf object detection project
3. Customize the object detection function
4. Re-deploy the updated project
5. Test the project

## Register the DeepLens device

Use documentation of standard registration steps.

## Deploy off the shelf object detection project

Create new project.  Choose project type.  Object detection. Next. Create.

Select the project.  Deploy to device.  Pick the device you registered.  Review.  Deploy.

## Test the project

Login to the device using the keyboard and monitor.  `aws_cam` is the username.  `Aws2018!` is the password.

`mplayer -demuxer lavf -lavfdopts format=mjpeg:probesize=32 /tmp/results.mjpeg`

## Customize the object detection function

Select the project.  Click on the function.  Takes you to Lambda console.

`Go to $LATEST` for editing. Paste in the updated function from `lab5/greengrassHelloWorld.py` .

Set the environment variables:

`BUCKET_NAME <your bucket>
DETECTION_THRESHOLD 0.55
S3S3_PUSH_THROTTLE_SECONDS 4`

Save.

Actions. Publish new version. Note the new version number.  Add a comment. Publish.

Back to DeepLens console.  Edit the project.  Click on `Function`.  Choose the new version number that you just published. Save.

## Re-deploy

Select the project.  Click `Deploy to device`.  Pick the device.  Click `Review`.  Click `Deploy` to replace the project on the device.  Takes a couple of minutes to complete the deployment and then another minute for the project to run, which is indicated by the top blue light staying lit.

## Test

Hold a bird picture in front of the DeepLens.  Hold it steady.  Keep it about 8 to 12 inches from the device.  You should see it detect the bird and highlight it with a thick purple bounding box.

Now check the lambda logs for the project.  Click on the project.  Click on lambda logs.  Pick the `deeplens-object-detection` log group.  Pick the most recent log stream.  Search for `error`.

Now check to see if the project was successful cropping the image and saving it to S3.  Go to your bucket.  Refresh. Navigate to the `birds` folder.  You will see a new folder created for today's date.  Within that, there will be subfolders for each minute in which there was a bird pushed.  Preview the jpg file to see the cropped image that was saved.

IoT console.  IoT permissions in user's IAM policy.

## Troubleshooting

### S3 access denied

You have not given permission to the Lambda function to create objects in s3.

In IAM, find the `AWSDeepLensGreengrassGroupRole` and extend it by attaching the `AmazonS3FullAccess` policy.

### Registration hangs

Ensure you are not on VPN.

If deeplens.amazon.net hangs when trying to connect with the device over its softAP SSID, try DeepLens.config instead.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
