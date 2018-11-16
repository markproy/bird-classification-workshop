#!/bin/bash

# This script starts or stops all notebook instances across all accounts.

# ./notebooks_state_all stop
# ./notebooks_state_all start

if [ $# -lt 1 ]
then
  echo Pass indication of whether to stop or start, as in ./notebooks_state_all.sh stop
  exit 1
fi

echo Performing action on notebook instances of all accounts: $1...

let ProfileNumber=0
while [ $ProfileNumber -lt 8 ]
do
  let ProfileNumber=$ProfileNumber+1
  set -x
  ./notebooks_state.sh $1 deeplens-$ProfileNumber &>/dev/null &
  set +x
done
