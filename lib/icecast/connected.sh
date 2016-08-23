#!/bin/sh

echo `date` connected >> /share/actions.log

curl -X POST $CALLBACK_URL/connect/$CLIENT_TOKEN
