#*****************************************************
#                                                    *
# Copyright 2018 Amazon.com, Inc. or its affiliates. *
# All Rights Reserved.                               *
#                                                    *
#*****************************************************
""" A sample lambda for object detection and highlighting birds"""
from threading import Thread, Event, Timer
import os
import json
import numpy as np
import greengrasssdk
import sys
import datetime
import time
import awscam
import cv2
import copy # to copy an image
import urllib
import zipfile
import mo

# Set the name of the S3 bucket used to deposit cropped jpg images of birds.
BUCKET_NAME = os.environ['BUCKET_NAME']

# Set the number of seconds to use as a buffer between calls to push
# cropped images to S3. Trying to avoid a flood of pictures of the
# same thing.
S3_PUSH_THROTTLE_SECONDS = int(os.environ['S3_PUSH_THROTTLE_SECONDS'])

# Set the threshold for confidence level of object detection.  Will only
# highlight objects as being detected if the model indicates the probability
# is at least this high.
DETECTION_THRESHOLD = float(os.environ['DETECTION_THRESHOLD'])

# Path of the SSD object detection model
SSD_MODEL_PATH = '/opt/awscam/artifacts/mxnet_deploy_ssd_resnet50_300_FP16_FUSED.xml'

# Visualization settings for bounding boxes
BOX_THICKNESS      = 10
BIRD_BOX_THICKNESS = 25

FONT_THICKNESS      = 6
BIRD_FONT_THICKNESS = 10

FONT_SCALE       = 2.5
BIRD_FONT_SCALE  = 5.0

TEXT_OFFSET      = 15
BIRD_TEXT_OFFSET = 30

BOX_COLOR      = (255, 165, 20)      # Light Blue
BIRD_BOX_COLOR = (255, 0, 204)       # Purple

# Create a greengrass core sdk client
client = greengrasssdk.client('iot-data')

# The information exchanged between IoT and clould has a topic and a
# message body. This is the topic used to send messages to cloud.
iot_topic = '$aws/things/{}/infer'.format(os.environ['AWS_IOT_THING_NAME'])

client.publish(topic=iot_topic, payload='At start of lambda function')

# boto3 is not installed on device by default. Install it if it is not
# already present.

boto_dir = '/tmp/boto_dir'
if not os.path.exists(boto_dir):
    os.mkdir(boto_dir)
    urllib.urlretrieve('https://s3.amazonaws.com/dear-demo/boto_3_dist.zip',
                        '/tmp/boto_3_dist.zip')
    with zipfile.ZipFile('/tmp/boto_3_dist.zip', 'r') as zip_ref:
        zip_ref.extractall(boto_dir)
sys.path.append(boto_dir)

import boto3

client.publish(topic=iot_topic, payload='Completed import of boto3')

class LocalDisplay(Thread):
    """ Class for facilitating the local display of inference results
        (as images). The class is designed to run on its own thread. In
        particular the class dumps the inference results into a FIFO
        located in the tmp directory (which lambda has access to). The
        results can be rendered using mplayer by typing:
        mplayer -demuxer lavf -lavfdopts format=mjpeg:probesize=32 /tmp/results.mjpeg
    """
    def __init__(self, resolution):
        """ resolution - Desired resolution of the project stream """
        # Initialize the base class, so that the object can run on its own
        # thread.
        super(LocalDisplay, self).__init__()
        # List of valid resolutions
        RESOLUTION = {'1080p' : (1920, 1080),
                      '720p'  : (1280,  720),
                      '480p'  : ( 858,  480)}
        if resolution not in RESOLUTION:
            raise Exception("Invalid resolution")
        self.resolution = RESOLUTION[resolution]
        # Initialize the default image to be a white canvas. Clients
        # will update the image when ready.
        self.frame = cv2.imencode('.jpg', 255*np.ones([640, 480, 3]))[1]
        self.stop_request = Event()

    def run(self):
        """ Overridden method that continually dumps images to the desired
            FIFO file.
        """
        # Path to the FIFO file. The lambda only has permissions to the tmp
        # directory. Pointing to a FIFO file in another directory
        # will cause the lambda to crash.
        result_path = '/tmp/results.mjpeg'
        # Create the FIFO file if it doesn't exist.
        if not os.path.exists(result_path):
            os.mkfifo(result_path)
        # This call will block until a consumer is available
        with open(result_path, 'w') as fifo_file:
            while not self.stop_request.isSet():
                try:
                    # Write the data to the FIFO file. This call will block
                    # meaning the code will come to a halt here until a consumer
                    # is available.
                    fifo_file.write(self.frame.tobytes())
                except IOError:
                    continue

    def set_frame_data(self, frame):
        """ Method updates the image data. This currently encodes the
            numpy array to jpg but can be modified to support other encodings.
            frame - Numpy array containing the image data of the next frame
                    in the project stream.
        """
        ret, jpeg = cv2.imencode('.jpg', cv2.resize(frame, self.resolution))
        if not ret:
            raise Exception('Failed to set frame data')
        self.frame = jpeg

    def join(self):
        self.stop_request.set()

def push_to_s3(img, index):
    """ Utility function to push a jpg image to an S3 bucket as a jpg file.
        Index parameter is to ensure unique filenames even if multiple jpg
        files are pushed in the same one second time interval.
        The img parameter is a byte array representing the jpg image.
    """
    try:
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

        client.publish(topic=iot_topic, payload="Response: {}".format(response))
        client.publish(topic=iot_topic, payload="Bird pushed to S3")
    except Exception as e:
        msg = "Pushing to S3 failed: " + str(e)
        client.publish(topic=iot_topic, payload=msg)

def load_model(path):
    # The sample projects come with optimized artifacts, hence only the artifact
    # path is required.

    # Load the model onto the GPU.
    client.publish(topic=iot_topic, payload='Loading object detection model')
    m = awscam.Model(path, {'GPU': 1})
    client.publish(topic=iot_topic, payload='Object detection model loaded')
    return m

def greengrass_infinite_infer_run():
    client.publish(topic=iot_topic, payload='At start of greengrass_infinite_infer_run')
    client.publish(topic=iot_topic, payload='DETECTION_THRESHOLD: {}'.format(str(DETECTION_THRESHOLD)))
    client.publish(topic=iot_topic, payload='S3_PUSH_THROTTLE_SECONDS: {}'.format(str(S3_PUSH_THROTTLE_SECONDS)))
    client.publish(topic=iot_topic, payload='BUCKET_NAME: {}'.format(BUCKET_NAME))

    try:

        # This object detection model is implemented as single shot detector (ssd), since
        # the number of labels is small we create a dictionary that will help us convert
        # the machine labels to human readable labels.
        model_type = 'ssd'
        output_map = {1: 'aeroplane', 2: 'bicycle', 3: 'bird', 4: 'boat', 5: 'bottle', 6: 'bus',
                      7 : 'car', 8 : 'cat', 9 : 'chair', 10 : 'cow', 11 : 'dinning table',
                      12 : 'dog', 13 : 'horse', 14 : 'motorbike', 15 : 'person',
                      16 : 'pottedplant', 17 : 'sheep', 18 : 'sofa', 19 : 'train',
                      20 : 'tvmonitor'}
        # Create a local display instance that will dump the image bytes to a FIFO
        # file that the image can be rendered locally.
        local_display = LocalDisplay('480p')
        local_display.start()

        # load the SSD object detection model
        model = load_model(SSD_MODEL_PATH)

        # The height and width of the training set images
        input_height = 300
        input_width = 300

        # Keep track of the timestamp of the last bird dected. used to help avoid flooding s3
        last_bird_pushed = 0
        last_frame = 0

        # Do inference until the lambda is killed.
        while True:
            # Get a frame from the video stream
            ret, frame = awscam.getLastFrame()
            if not ret:
                raise Exception('Failed to get frame from the stream')

            # Resize frame to the same size as the training set, and make a copy
            # of the frame that will be used for cropping if we find a bird
            frame_without_boxes = copy.copy(frame)
            frame_resize = cv2.resize(frame, (input_height, input_width))

            # Run the images through the inference engine and parse the results using
            # the parser API, note it is possible to get the output of doInference
            # and do the parsing manually, but since it is a ssd model,
            # a simple API is provided.
            parsed_inference_results = model.parseResult(model_type,
                                                         model.doInference(frame_resize))

            # Compute the scale in order to draw bounding boxes on the full resolution
            # image.
            yscale = float(frame.shape[0]/input_height)
            xscale = float(frame.shape[1]/input_width)

            # Dictionary to be filled with labels and probabilities for MQTT
            cloud_output = {}

            # Get the detected objects and probabilities
            i = 0
            num_birds_in_this_frame = 0
            for obj in parsed_inference_results[model_type]:
                if obj['prob'] > DETECTION_THRESHOLD:
                    # Add bounding boxes to full resolution frame
                    xmin = int(xscale * obj['xmin']) \
                           + int((obj['xmin'] - input_width/2) + input_width/2)
                    ymin = int(yscale * obj['ymin'])
                    xmax = int(xscale * obj['xmax']) \
                           + int((obj['xmax'] - input_width/2) + input_width/2)
                    ymax = int(yscale * obj['ymax'])

                    bbox_color     = BOX_COLOR
                    bbox_thickness = BOX_THICKNESS
                    font_thickness = FONT_THICKNESS
                    font_scale     = FONT_SCALE
                    # Amount to offset the label/probability text above the bounding box.
                    text_offset    = TEXT_OFFSET

                    # if the current object is a bird, use a different bounding
                    # box to make it stand out.  also keep track of the number
                    # of birds in this frame and the timestamp.
                    obj_name = output_map[obj['label']]
                    if (obj_name == 'bird'):
                        num_birds_in_this_frame += 1
                        timestamp = int(time.time())
                        time_window = (timestamp - last_bird_pushed)

                        # make the bounding box stand out, since it's a bird
                        bbox_color     = BIRD_BOX_COLOR
                        bbox_thickness = BIRD_BOX_THICKNESS
                        font_thickness = BIRD_FONT_THICKNESS
                        font_scale     = BIRD_FONT_SCALE
                        text_offset    = BIRD_TEXT_OFFSET

                    # See https://docs.opencv.org/3.4.1/d6/d6e/group__imgproc__draw.html
                    # for more information about the cv2.rectangle method.
                    # Method signature: image, point1, point2, color, and tickness.
                    cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), bbox_color, bbox_thickness)

                    # See https://docs.opencv.org/3.4.1/d6/d6e/group__imgproc__draw.html
                    # for more information about the cv2.putText method.
                    # Method signature: image, text, origin, font face, font scale, color,
                    # and thickness
                    cv2.putText(frame, "{}: {:.2f}%".format(obj_name, obj['prob'] * 100),
                                (xmin, ymin-text_offset),
                                cv2.FONT_HERSHEY_SIMPLEX, font_scale, bbox_color, font_thickness)

                    # If it's a bird, crop the image and save a copy to s3
                    # if we haven't detected birds in the last few seconds
                    if ((obj_name == 'bird') and (time_window > S3_PUSH_THROTTLE_SECONDS)):
                        # crop and push, add a buffer around the bounding box area that
                        # the single shot detection model provides, so that we don't end up
                        # trimming any body parts of the bird
                        crop_img = frame_without_boxes[(ymin - (3 * BIRD_BOX_THICKNESS)):(ymax + (3 * BIRD_BOX_THICKNESS)),
                                                       (xmin - (3 * BIRD_BOX_THICKNESS)):(xmax + (3 * BIRD_BOX_THICKNESS))]
                        push_to_s3(crop_img, i)

                        # remember the time of the last push
                        last_bird_pushed = timestamp

                    # Store label and probability to send to cloud
                    cloud_output[output_map[obj['label']]] = obj['prob']
                    i += 1

            # Set the next frame in the local display stream.
            local_display.set_frame_data(frame)
            last_frame = frame

            # Send results to the cloud
            if (len(cloud_output) > 0):
                client.publish(topic=iot_topic, payload=json.dumps(cloud_output))
    except Exception as ex:
        client.publish(topic=iot_topic, payload='Error in object detection lambda: {}'.format(ex))

client.publish(topic=iot_topic, payload='Calling greengrass_infinite_infer_run')
greengrass_infinite_infer_run()
