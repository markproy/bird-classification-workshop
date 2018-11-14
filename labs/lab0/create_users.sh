#!/bin/bash

# This script creates a set of DeepLens workshop IAM users.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# The second argument is the workshop Pod number.  At reInvent, there are 15 pods
# in a room, with each pod containing 8 stations.
# The 3rd argument is the password for each user.

# ./create_users.sh account1 01 'pw'
# ./create_users.sh account1 02 'pw'
# ./create_users.sh account2 03 'pw'
# ./create_users.sh account2 04 'pw'
# ...
# ./create_users.sh account7 13 'pw'
# ./create_users.sh account7 14 'pw'
# ./create_users.sh account8 15 'pw'

Profile=$1
Pod=$2
Password=$3
GroupName=deeplens-group

echo $Profile

echo Creating a set of 8 users for the pod ${Pod}...

let Seat=0
while [ $Seat -lt 8 ]
do
  let Seat=$Seat+1
  UserSuffix=${Pod}-"0${Seat}"
  echo $UserSuffix

  UserName=user-${UserSuffix}
  set -x
  aws iam create-user --profile ${Profile} --user-name ${UserName}
  aws iam create-login-profile --profile ${Profile} --user-name ${UserName} --password ${Password}
  aws iam add-user-to-group --profile ${Profile} --group-name ${GroupName} --user-name ${UserName}
  set +x
done
