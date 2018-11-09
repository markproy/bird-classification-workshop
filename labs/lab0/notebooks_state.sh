#!/bin/bash

let i=0
while [ $i -lt 15 ]
do
       let i=$i+1
       if [ $i -lt 10 ]; then
          UserSuffix="0${i}"
       else
          UserSuffix=${i}
       fi
       echo $UserSuffix

       if [ $1 == "start" ]; then
          Command="start-notebook-instance"
       else
          Command="stop-notebook-instance"
       fi
       echo $Command
       set -x
       aws sagemaker --profile default ${Command} \
          --notebook-instance-name "BirdClassificationWorkshop${UserSuffix}"
done
