#!/bin/sh

# this script should be run in a terminal window inside your SageMaker notebook
# that was created as part of the workshop.

if [ $# -lt 1 ]
then
  echo Pass the user suffix, as in:
  echo   bash test_all.sh 02
  exit 1
fi

export ENDPOINT_NAME=nabirds-species-identifier-$1

python test_direct_sample.py ../../test_images/eastern-bluebird.jpg
python test_direct_sample.py ../../test_images/northern-cardinal.jpg
python test_direct_sample.py ../../test_images/american-goldfinch.jpg
python test_direct_sample.py ../../test_images/purple-martin.jpg
