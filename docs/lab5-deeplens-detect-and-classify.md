# Lab 5 - Use AWS DeepLens to detect birds and trigger classification

In this lab, you will use AWS DeepLens to detect birds and trigger classification of the bird species.  Here are the steps:

1. Register the DeepLens device
2. Deploy the Object Detection sample project provided with DeepLens
3. Customize the object detection project
4. Re-deploy the updated project
5. Test the project

## Register the DeepLens device

Use documentation of standard registration steps.

* Name the device.  Use the name provided on a sticker on the device (e.g., `L25`).
* Permissions.  Should be all set based on CloudFormation template that already set up the proper permissions.
* Certificate.  Download the certificate to be used on the device.  You will need to upload this certificate to the device in an upcoming step.
* Next.
* Use paper clip to enable the device softAP WiFi.  You will connect to the device WiFi to upload the certificate.
* Once the middle light on the device is blinking, connect to the device WiFi.  The SSID is shown on the sticker on the device (e.g., `AMDC-UB82`).
* Once you are connected to the device WiFi, click `Next` to continue the setup.
* Select a `Wired connection` using `Ethernet-USB Adapter`.  Click `Use Ethernet`.  Click `Connect`.
* Upload the certificate that you downloaded earlier.  Click `Edit` even if it looks like there is already a certificate attached.  This could be from an earlier registration.  Click `Browse` and locate the certificate zip file (e.g., `certificates-deeplens_JVHM9GHxSqRE84fw.zip`) you downloaded earlier.  Click `Upload zip file`.
* Leave the device password as is.  For this workshop, you will see the password on a sticker on the device.
* Click `Finish`.  This will disconnect you from the device WiFi, and will complete the registration on the device.
* Re-connect to your network (non-device WiFi, or Ethernet).
* Click `Open AWS DeepLens Console`.
* You should see `Registration status` of `Registered`, and a `Device status` of `Online`.

## Deploy off the shelf object detection project

* Click `Deploy a project`.
* On the `Projects` console, click `Create new project`.
* Use a project template called `Object detection`.  Click `Next`, and then click `Create`.  Project creation could take a few seconds.  
* Once the project is created, select it, and click `Deploy to device`. Pick the device you registered in the previous step. Click `Review`. Click `Deploy`.
* You will see the status at the top of the page indicating `Deployment of project is in progress`, with an indication of percent complete of the model download.  It will then create a Greengrass deployment.  After a few minutes, you will see the status bar change from blue to green indicating `Deployment of project succeeded`.
* Soon thereafter, the topmost blue light on the device should turn on and remain lit.

## Test the project

Login to the device using the keyboard and monitor.  `aws_cam` is the username.  `Aws2018!` is the password.

Once the desktop is displayed, right click on the desktop and select `Open Terminal`.  In the terminal window, launch a viewer to see the project stream being provided by the AWS DeepLens device.

```
mplayer -demuxer lavf -lavfdopts format=mjpeg:probesize=32 /tmp/results.mjpeg
```
This will bring up a new window showing you what the device is seeing.  For the Object Detection project, it will also show you blue bounding boxes and confidence levels each time it identifies one of the 20 objects it has been trained to detect (e.g., person, sofa, tv monitor).

## Customize the object detection project

### Review the code you will be providing

Now you will customize the object detection project to use a new function that will perform specific actions when it detects a bird object:

* Display a bold purple bounding box to highlight the bird.
* Crop the scene to that bounding box.
* Save the cropped image as a jpg to a `birds` folder in your S3 bucket.

In this section, we will review some of the key pieces of code that are used in the customized object detection function.  The [full code](../labs/lab5/greengrassHelloWorld.py) can be seen in `labs/lab5/greengrassHelloWorld.py`.

#### Code for cropping the image and calling push_to_s3 function

Here is the code from the main loop of the inference function.  If the object detection model finds any birds, each one is cropped and saved to S3.

```
# If it's a bird, crop the image and save a copy to s3
# if we haven't detected birds in the last few seconds
if ((obj_name == 'bird') and (time_window > S3_PUSH_THROTTLE_SECONDS)):
    # crop and push
    crop_img = frame_without_boxes[ymin:ymax, xmin:xmax]
    push_to_s3(crop_img, i)
    # remember the time of the last push
    last_bird_pushed = timestamp
# Store label and probability to send to cloud
cloud_output[output_map[obj['label']]] = obj['prob']
```

#### Code from push_to_s3 for publishing the cropped image to S3

Here is code from a utility function that takes the cropped image, encodes it as a jpg file, and creates an S3 object for the file.  It stores the file in the `birds` folder in the supplied S3 bucket, and it automatically creates subfolders based on date and time for an organized collection of cropped images.

```
timestamp = int(time.time())
now = datetime.datetime.now()
key = "birds/{}_{}/{}_{}/{}_{}.jpg".format(now.month, now.day,
                                           now.hour, now.minute,
                                           timestamp, index)
s3 = boto3.client('s3')
encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 90]
_, jpg_data = cv2.imencode('.jpg', img, encode_param)
response = s3.put_object(ACL='public-read',
                         Body=jpg_data.tostring(),
                         Bucket=BUCKET_NAME,
                         Key=key)
```

### Detailed steps for customizing the project function

Here are the steps to follow to customize the project.

* Go to the `Project` part of the DeepLens console.
* Click on the name of the project you created earlier.  The console will take you to the details page for that project.
* Click on the function (e.g., `deeplens-object-detection/versions/1`), which will take you to the Lambda console.
* Click on `Go to $LATEST` so that you can edit the function in the console.
* Paste in the updated function from `labs/lab5/greengrassHelloWorld.py` .
* Set the environment variables.  Note that if you forget to add these environment variables, your project will deploy successfully but will not run.  The top blue light will never turn on.  Here are the three environment variables you need to set:

```
BUCKET_NAME = <your bucket>
DETECTION_THRESHOLD = 0.55
S3_PUSH_THROTTLE_SECONDS = 4
```
* Click `Save` to save the project with the updated function code and environment variables.
* On the `Actions` menu, click `Publish new version`. Note the new version number.  Add a comment. Click `Publish`.

### Updating the DeepLens project to use the new version of the function

Follow these steps to update your DeepLens project to be using the new version of the Lambda function you just created:

* Return back to DeepLens `Projects` console.  Click on `Edit` to edit the project content.  
* Under `Project Content`, click on `Function` (not the name of the function) to expand the project function editor.  
* Choose the new version number that you just published (should be the latest).
* Click `Save` to save your project edits.

## Re-deploy

* Click on `Deploy to device`.  
* Select your device.  Click `Review`. Confirm that you want to overwrite the project that is already deployed on the device. Click `Deploy`. This process then takes a couple of minutes to complete the deployment and then another minute for the project to run, which is indicated by the top blue light staying lit.

## Test

### Show some bird pictures to your DeepLens device

From your DeepLens terminal, use `mplayer` again to view the device's project video stream:

```
mplayer -demuxer lavf -lavfdopts format=mjpeg:probesize=32 /tmp/results.mjpeg
```

Hold a bird picture in front of the DeepLens.  Hold it steady.  Keep it about 8 to 12 inches from the device.  You should see it in the `mplayer` window, and you should see that the bird is detected and highlighted with a thick purple bounding box.

**insert picture here**

### Check to see that the cropped image was saved to S3

Now check to see if the project was successful cropping the image and saving it to S3.  Go to your bucket.  Refresh. Navigate to the `birds` folder.  You will see a new folder created for today's date.  Within that, there will be subfolders for each minute in which there was a bird pushed.  Preview the jpg file to see the cropped image that was saved.

### Now find out what species was identified

Two ways to do this:

1. Review the logs for the `IdentifySpeciesAndNotify` Lambda function.
2. IoT console.  **ensure IoT permissions in user's IAM policy.**

#### Reviewing Lambda logs for species

Go to the AWS Lambda console and select the `IdentifySpeciesAndNotify` function.  Click on the `Monitoring` tab.  Click on the `View logs in CloudWatch` button on the upper right corner of the screen above the metrics charts.

In CloudWatch, open the log stream that has the most recent event time.  Scan the log for output from your Lambda function.  Log entries for invocations are bracketed by an initial entry of `START RequestId` and a closing log entry of `REPORT RequestId` which displays the duration and memory size information.  If everything worked well, you will see an entry that starts with `msg` that will show you the results of the species identification.  If not, you may see an entry that says `An error occurred`.  One common example would be that you do not have your SageMaker endpoint up and running with the correct endpoint name (i.e., `nabirds-species-identifier`).

#### Using the IoT console to see the bird species results

From the DeepLens device page of the console, copy the IoT subscription topic and navigate to the IoT console.  Paste in the subscription topic.  Now show another bird to the device.  You should see the results in the IoT console.

## Troubleshooting

### Project successfully deployed, but top light never turns on

Be sure you have waited at least a minute after the successful deployment to give it a chance to run.

Now check the lambda logs for the project.  Click on the project.  Click on lambda logs.  Pick the `deeplens-object-detection` log group.  Pick the most recent log stream.  Search for `error`.

If the Lambda function is failing immediately when the DeepLens tries to load it, you may get errors in the `python_runtime` log.  From the `Device` page of the DeepLens console, navigate to the Greengrass logs (link near the bottom of the page).  From CloudWatch, choose the log group called `/aws/greengrass/GreengrassSystem/python_runtime`.  Open the log stream in this log group that has the latest event time.  If you had forgotten to add the environment variables to your Lambda function, your function would be failing to load.  The `python_runtime` log would show an error about its inability to find the `BUCKET_NAME` environment variable.

#### Other remediation steps

Try restarting greengrass.  

```
sudo systemctl restart greengrassd.service —no-block
```

If that does not work, try rebooting the DeepLens device.

If that does not work, navigate to the device in the DeepLens console and click `Remove project` to remove the project.  This will take a couple of minutes to complete.  You may need to refresh the console to see that it has been removed.  Deploy the project once again, and ensure this time the top light gets lit.

If that does not work, click on `Deregister the device`.  Then go back and repeat device registration and deploying the project.

### S3 access denied

You have not given permission to the Lambda function to create objects in s3.

In IAM, find the `AWSDeepLensGreengrassGroupRole` and extend it by attaching the `AmazonS3FullAccess` policy.

### DeepLens device registration hangs

Ensure you are not on VPN.

If deeplens.amazon.net hangs when trying to connect with the device over its softAP SSID, try DeepLens.config instead.

## Navigation

[Home](../README.md) - [Lab 1](lab1-image-prep.md) - [Lab 2](lab2-train-model.md) - [Lab 3](lab3-host-model.md) - [Lab 4](lab4-trigger-inference-from-s3.md) - [Lab 5](lab5-deeplens-detect-and-classify.md) - [Lab 6](lab6-text-notification.md) - [Troubleshooting](troubleshooting.md)
