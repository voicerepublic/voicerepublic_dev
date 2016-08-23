#!/bin/sh

echo `date` disconnected >> /share/actions.log

curl -X POST $CALLBACK_URL/disconnect/$CLIENT_TOKEN

# TODO does it work for s3fs (fuse)
# if not ditch s3fs and use s3/4cmd to upload here
sync

echo `date` synced >> /share/actions.log

curl -X POST $CALLBACK_URL/synced/$CLIENT_TOKEN
