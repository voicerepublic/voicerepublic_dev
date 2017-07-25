#!/bin/bash

curl -o runner.rb $RUNNER_ENDPOINT

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY

ruby runner.rb

exit $?
