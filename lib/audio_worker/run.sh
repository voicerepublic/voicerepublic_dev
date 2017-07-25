#!/bin/bash

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY

echo Fetch updated runner from $RUNNER_ENDPOINT

curl -o runner.rb $RUNNER_ENDPOINT

ruby runner.rb

exit $?
