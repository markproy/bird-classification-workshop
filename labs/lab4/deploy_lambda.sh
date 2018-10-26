#!/bin/sh
# This script deploys an updated lamnbda function.
# The lambda_code subdirectory must be pre-populated with the lambda function
# and the corresponding set of additional python packages that are required
# beyond those provided automatically by AWS Lambda.  In particular,
# numpy is often needed, but is not provided by default.
# Note that since AWS Lambda is run on Linux, the numpy packages cannot
# come from a Mac. The easiest way to get them is to use an EC2 Linux instance,
# install Python, create a virtual environment, install numpy in that environment,
# and copy the resulting packages.
# This script assumes you've already done this step and those packages are
# provided in the same subdirectory as the lambda function.

# this script should be run in a terminal window inside your SageMaker notebook
# that was created as part of the workshop.

if [ $# -lt 1 ]
then
  echo Pass the user suffix, as in:
  echo   bash deploy_lambda.sh 01
  exit 1
fi

FUNCTION_NAME=IdentifySpeciesAndNotify$1
PACKAGE_FILE_PREFIX=package

# First, create the lambda package as a zip file
cd lambda
zip -r9 ../$PACKAGE_FILE_PREFIX.zip .
cd ..

# Now deploy the resulting package
aws lambda update-function-code \
  --function-name $FUNCTION_NAME  \
  --zip-file fileb://./$PACKAGE_FILE_PREFIX.zip
