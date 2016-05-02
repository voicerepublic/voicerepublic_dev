#!/bin/sh

echo `date` stop >> /share/actions.log

JSON='{"client_token":"'$CLIENT_TOKEN'"}'
curl -X POST --data "$JSON" $CALLBACK_URL/disconnect
