#!/bin/sh

echo `date` disconnected >> /share/actions.log

JSON='{"client_token":"'$CLIENT_TOKEN'"}'

curl -X POST --data "$JSON" $CALLBACK_URL/disconnect

# TODO does it work for s3fs (fuse)
# if not ditch s3fs and use s3/4cmd to upload here
sync

echo `date` synced >> /share/actions.log

curl -X POST --data "$JSON" $CALLBACK_URL/synced
