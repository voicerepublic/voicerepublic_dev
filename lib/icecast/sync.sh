#!/bin/sh

echo `date` syncing >> /share/actions.log

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set default.region $AWS_REGION

aws s3 sync /share $AWS_STORAGE >> sync.log
