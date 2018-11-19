#!/bin/bash
# This script deletes all Bird Classification Workshop Cloud Formation stacks
# across all workshop accounts.
# ./delete_stacks_all.sh us-east-1

if [ $# -lt 1 ]
then
  echo Pass the region, as in: ./delete_stacks_all.sh us-east-1
  exit 1
fi

Region=$1

./delete_stacks.sh deeplens-1 01 $Region
./delete_stacks.sh deeplens-1 02 $Region

./delete_stacks.sh deeplens-2 03 $Region
./delete_stacks.sh deeplens-2 04 $Region

./delete_stacks.sh deeplens-3 05 $Region
./delete_stacks.sh deeplens-3 06 $Region

./delete_stacks.sh deeplens-4 07 $Region
./delete_stacks.sh deeplens-4 08 $Region

./delete_stacks.sh deeplens-5 09 $Region
./delete_stacks.sh deeplens-5 10 $Region

./delete_stacks.sh deeplens-6 11 $Region
./delete_stacks.sh deeplens-6 12 $Region

./delete_stacks.sh deeplens-7 13 $Region
./delete_stacks.sh deeplens-7 14 $Region

./delete_stacks.sh deeplens-8 15 $Region
