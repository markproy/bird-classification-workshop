import json          # for parsing the results of the SageMaker inference, and the lambda event
import urllib.parse  # for parsing the s3 bucket name and key
import os            # for accessing environment variables
import boto3         # for access to s3, SNS, and SageMaker api's
import numpy as np   # for interpreting results from the SageMaker inference

print('Loading function')

print('Getting access to s3, sns, and sagemaker runtime')
s3 = boto3.client('s3')
sns = boto3.client('sns')
runtime = boto3.client(service_name='runtime.sagemaker')

# Load the bird species names. Needed for creating a useful Message
# based on the SageMaker inference results.
object_categories = ['Purple Martin','Northern Cardinal','American Goldfinch','Eastern Bluebird']

TOP_K = 2                   # identifies number of species to message about when uncertain. Could move this to lambda env var.
CERTAINTY_THRESHOLD = 0.70  # the confidence level under which we will return multiple options. Could move this to lambda env var.

def lambda_handler(event, context):
    s3_object_response = ''

    # Get the s3 object based on the event. Log the key, length (jpg size),
    # and content type (image)
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'],
                                    encoding='utf-8')
    try:
        # Retrieve the bird jpg image from s3
        s3_object_response = s3.get_object(Bucket=bucket, Key=key)
        print("KEY: " + key)
        print("CONTENT LENGTH: " + str(s3_object_response['ContentLength']))
        print("CONTENT TYPE: " + s3_object_response['ContentType'])
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e

    # Run the bird species inference using the SageMaker runtime. Endpoint must
    # already be up and running.
    result = b''
    try:
        print('Invoking bird species identification endpoint')
        # set up the payload for calling the SageMaker image classification inference
        # read the jpg image from the s3 object response into a byte array.
        payload = s3_object_response['Body'].read()
        endpoint_name = os.environ['SAGEMAKER_ENDPOINT_NAME']
        endpoint_response = runtime.invoke_endpoint(
                                    EndpointName=endpoint_name,
                                    ContentType='application/x-image',
                                    Body=payload)
        # grab the inference result, which includes an array of probabilities,
        # each one corresponding to the likelihood that the image represents a bird
        # of that species.
        result = endpoint_response['Body'].read()
    except Exception as e:
        print(e)
        print('Error invoking bird species identification endpoint: {}'.format(endpoint_name))
        raise e

    # Format a message that identifies the species, or the top most likely species
    # First, turn the json response string into a json object
    result = json.loads(result)
#    print('result from image classification endpoint is: \n' +
#        json.dumps(result, sort_keys=True, indent=4, separators=(',', ': ')))

    # make a 2d array to capture the class index as well as the probability
    # first make an array of indexes
    indexes = np.empty(len(result))
    for i in range(0, len(result)):
        indexes[i] = i
    # now make the 2d array by stacking together vertically the probability array
    # and the index array. transpose the results to ease the subsequent sorting and indexing.
    full_results = np.vstack((indexes, result))
    transposed_full_results = full_results.T

    # make a copy sorted in descending order of species probability
    sorted_transposed_results = transposed_full_results[transposed_full_results[:,1].argsort()[::-1]]

    # if the top answer is fairly certain, give a confident simple answer that
    # we identified the species.  In either case, show the confidence level as
    # a probability out to two decimal places in parentheses after the species name.
    # For example, "Woodpecker (0.93)".
    msg = ''
    if (sorted_transposed_results[0][1] > CERTAINTY_THRESHOLD):
        msg = 'Bird [' + key + '] is a: ' + object_categories[int(sorted_transposed_results[0][0])] + '(' + \
                '{:2.2f}'.format(sorted_transposed_results[0][1]) + ')'
    # otherwise, provide a more nuanced result, giving the top N possible species
    else:
        msg = 'Bird [' + key + '] may be a: '
        for top_index in range(0, TOP_K):
            if (top_index > 0):
                msg = msg + ', or '
            msg = msg + object_categories[int(sorted_transposed_results[top_index][0])] + '(' + \
                      '{:2.2f}'.format(sorted_transposed_results[top_index][1]) + ')'

    print('msg: ' + msg)

    # Publish the message to SNS, which can in turn send an SMS message to interested parties.
    response = ''
    try:
        # get topic ARN from Lambda envrionment variable
        mySNSTopicARN = os.environ['SNS_TOPIC_ARN']
        print('Publishing message to SNS topic: {}'.format(mySNSTopicARN))
        response = sns.publish(TopicArn=mySNSTopicARN, Message=msg)
        print("SNS Publish Response: {}".format(response))
    except Exception as e:
        print(e)
        print('Error publishing message to SNS.')
        raise e

    return 'success' #response['content-type']
