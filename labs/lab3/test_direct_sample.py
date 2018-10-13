import json          # for parsing the results of the SageMaker inference, and the lambda event
import urllib.parse  # for parsing the s3 bucket name and key
import boto3         # for access to s3, SNS, and SageMaker api's
import os            # for environment variables
import sys           # for command line args
import numpy as np   # for interpreting results from the SageMaker inference
import pandas as pd  # for getting absolute class_id from the relative class_id
from os import walk  # for getting files from a directory

DEFAULT_ENDPOINT_NAME = 'nabirds-species-identifier'

# Getting access to sagemaker runtime
runtime = boto3.client(service_name='runtime.sagemaker')

# Load the bird species names. Needed for creating a useful Message
# based on the SageMaker inference results.
object_categories = ['Purple Martin','Northern Cardinal','American Goldfinch','Eastern Bluebird']

TOP_K = 2                   # identifies number of species to message about when uncertain. Could move this to lambda env var.
CERTAINTY_THRESHOLD = 0.85  # the confidence level under which we will return multiple options. Could move this to lambda env var.

leaf_classes_df = pd.read_csv('leaf_classes_sample.txt', names=['class_id'], header=None)

def nabird_classify_image(image_as_bytes, endpoint_name):
    # Run the bird species inference using the SageMaker runtime. Endpoint must
    # already be up and running.
    result = b''
    try:
        # set up the payload for calling the SageMaker image classification inference
        # read the jpg image from the s3 object response into a byte array.
        payload = image_as_bytes
        endpoint_response = runtime.invoke_endpoint(
                                    EndpointName=endpoint_name,
                                    ContentType='application/x-image',
                                    Body=payload)
        # grab the inference result, which includes an array of probabilities,
        # each one corresponding to the likelhood that the image represents a bird
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
    top_k_indexes = []
    for i in range(TOP_K):
        rel_class_id = int(sorted_transposed_results[i][0])
        abs_class_id = leaf_classes_df.iloc[rel_class_id]['class_id']
        top_k_indexes.append(abs_class_id)

    msg = ''
    if (sorted_transposed_results[0][1] > CERTAINTY_THRESHOLD):
        rel_class_id = int(sorted_transposed_results[0][0])
        abs_class_id = leaf_classes_df.iloc[rel_class_id]['class_id']
        msg = 'Bird is a: ' + \
            object_categories[int(sorted_transposed_results[0][0])] + '(' + \
            '{:2.2f}'.format(sorted_transposed_results[0][1]) + ')[' + \
            str(abs_class_id) + ']'

    # otherwise, provide a more nuanced result, giving the top K possible species
    else:
        msg = 'Bird may be a: '
        for top_index in range(0, TOP_K):
            if (top_index > 0):
                msg = msg + ', or '
            rel_class_id = int(sorted_transposed_results[top_index][0])
            abs_class_id = leaf_classes_df.iloc[rel_class_id]['class_id']

#            print('\nrel: ' + str(rel_class_id) + ', abs: ' + str(abs_class_id))
#            print('cat: ' + object_categories[int(sorted_transposed_results[top_index][0])])

            msg = msg + object_categories[int(sorted_transposed_results[top_index][0])] + '(' + \
                      '{:2.2f}'.format(sorted_transposed_results[top_index][1]) + ')[' + \
                      str(abs_class_id) + ']'

    return msg, top_k_indexes

try:
    epn = os.environ['ENDPOINT_NAME']
except Exception as e:
    epn = DEFAULT_ENDPOINT_NAME

if (len(sys.argv) <= 1):
    print('need to pass a base directory, as in ''python test_CUB.py ~/ML/birds/CUB_200_2011/CUB_200_2011/images''')
    exit
else:
    ### test single jpg
    filename = sys.argv[1]
    f = open(filename, 'rb')
    img = f.read()
    msg, top_k = nabird_classify_image(img, epn)
    print(msg)
