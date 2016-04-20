#!/bin/sh

echo `date` ready >> /share/actions.log

JSON='{"public_ip_address":"'$PUBLIC_IP'","client_token":"'$CLIENT_TOKEN'"}'
curl -X POST --data "$JSON" $CALLBACK_URL/complete
