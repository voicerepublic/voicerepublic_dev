#!/bin/sh

echo `date` ready >> /share/actions.log

JSON='{"public_ip_address":"'$PUBLIC_IP'"}'

curl -X POST $CALLBACK_URL/ready/$CLIENT_TOKEN
