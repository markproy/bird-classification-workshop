#!/bin/bash

# This script creates a set of DeepLens workshop IAM users.
# The first argument is an AWS credentials profile that corresponds to a configured
# entry in the AWS credentials configuration file to refer to a specific IAM user.
# The second argument is the workshop Pod number.  At reInvent, there are 15 pods
# in a room, with each pod containing 8 stations.

# ./create_users account1 01 'pw'
# ./create_users account1 02 'pw'
# ./create_users account2 03 'pw'
# ./create_users account2 04 'pw'
# ...
# ./create_users account7 13 'pw'
# ./create_users account7 14 'pw'
# ./create_users account8 15 'pw'

Profile=$1
Pod=$2
Password=$3
GroupName=workshop-user

echo $Profile

let Seat=0
while [ $Seat -lt 8 ]
do
  let Seat=$Seat+1
  UserSuffix=${Pod}-"0${Seat}"
  echo $UserSuffix

  UserName=user-${UserSuffix}
  set -x
  aws iam create-user --user-name ${UserName}
  aws iam create-login-profile --user-name ${UserName} --password ${Password}
  aws iam add-user-to-group --group-name ${GroupName} --user-name ${UserName}
  set +x
done
