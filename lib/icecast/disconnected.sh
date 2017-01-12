#!/bin/sh

echo `date` disconnected >> /share/actions.log

COMMAND="curl -X POST $CALLBACK_URL/disconnect/$CLIENT_TOKEN"

N=0
until [ $N -ge 10 ]
do
    $COMMAND && break
    N=$[$N+1]
    echo `date` "failed to report disconnected, retry $N" >> /share/actions.log
done

if [ $N = 10 ]
then
    echo `date` "failed to report disconnected, giving up" >> /share/actions.log
fi

# TODO does it work for s3fs (fuse)
# if not ditch s3fs and use s3/4cmd to upload here
sync

echo `date` synced >> /share/actions.log

COMMAND="curl -X POST $CALLBACK_URL/synced/$CLIENT_TOKEN"

N=0
until [ $N -ge 10 ]
do
    $COMMAND && exit
    N=$[$N+1]
    echo `date` "failed to report synced, retry $N" >> /share/actions.log
done

echo `date` "failed to report synced, giving up" >> /share/actions.log
