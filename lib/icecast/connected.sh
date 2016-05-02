#!/bin/sh

echo `date` start >> /share/actions.log

JSON='{"client_token":"'$CLIENT_TOKEN'"}'
curl -X POST --data "$JSON" $CALLBACK_URL/connect
