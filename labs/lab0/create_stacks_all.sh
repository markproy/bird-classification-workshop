#!/bin/bash
# This script creates all Bird Classification Workshop Cloud Formation stacks
# across all workshop accounts.
# ./create_stacks_all.sh us-east-1

if [ $# -lt 1 ]
then
  echo Pass the region, as in: ./create_stacks_all.sh us-east-1
  exit 1
fi

Region=$1

./create_stacks.sh deeplens-1 01 $Region
./create_stacks.sh deeplens-1 02 $Region

./create_stacks.sh deeplens-2 03 $Region
./create_stacks.sh deeplens-2 04 $Region

./create_stacks.sh deeplens-3 05 $Region
./create_stacks.sh deeplens-3 06 $Region

./create_stacks.sh deeplens-4 07 $Region
./create_stacks.sh deeplens-4 08 $Region

./create_stacks.sh deeplens-5 09 $Region
./create_stacks.sh deeplens-5 10 $Region

./create_stacks.sh deeplens-6 11 $Region
./create_stacks.sh deeplens-6 12 $Region

./create_stacks.sh deeplens-7 13 $Region
./create_stacks.sh deeplens-7 14 $Region

./create_stacks.sh deeplens-8 15 $Region
