#!/bin/bash

echo Configure AWS...

aws configure set aws_access_key_id $AWS_ACCESS_KEY
aws configure set aws_secret_access_key $AWS_SECRET_KEY

echo Update runner from $RUNNER_ENDPOINT

curl -o runner.rb $RUNNER_ENDPOINT

echo Running service...

ruby runner.rb

exit $?
