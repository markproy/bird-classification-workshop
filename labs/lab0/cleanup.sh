#!/bin/sh
# aws sagemaker list-notebook-instances --name-contains ''nabirds-species-identifier-'' --output text | cut -f 6 | xargs -I{} aws sagemaker delete-notebook-instance --notebook-instance-name {}
aws sagemaker list-models --name-contains ''birds-'' --output text | cut -f 4 | xargs -I{} aws sagemaker delete-model --model-name {}
