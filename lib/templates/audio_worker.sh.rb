#!/bin/bash

# TODO call home

AWS_CREDENTIALS=<%= aws_credentials %>
echo $AWS_CREDENTIALS > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

su -c 'QUEUE=<%= queue_endpoint %> ruby /home/admin/audio_worker/runner.rb' admin
