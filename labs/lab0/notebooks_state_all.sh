#!/bin/bash
# This script starts or stops all notebook instances across all accounts.
# ./notebooks_state_all.sh stop us-east-1
# ./notebooks_state_all.sh start us-east-1

if [ $# -lt 2 ]
then
  echo Pass indication of whether to stop or start plus region, as in ./notebooks_state_all.sh stop us-east-1
  exit 1
fi

REGION=$2

echo In $REGION, performing action on notebook instances of all accounts: $1...

let ProfileNumber=0
while [ $ProfileNumber -lt 8 ]
do
  let ProfileNumber=$ProfileNumber+1
  set -x
  ./notebooks_state.sh $1 deeplens-$ProfileNumber $REGION &>/dev/null &
  set +x
done
