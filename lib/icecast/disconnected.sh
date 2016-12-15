#!/bin/sh

echo `date` disconnected >> /share/actions.log

command="curl -X POST $CALLBACK_URL/disconnect/$CLIENT_TOKEN"

n=0
until [ $n -ge 10 ]
do
    $command && break
    echo `date` "failed to report disconnected, retry" >> /share/actions.log
    n=$[$n+1]
done

if [ n = 10 ]
then
    echo `date` "failed to report disconnected, giving up" >> /share/actions.log
fi

# TODO does it work for s3fs (fuse)
# if not ditch s3fs and use s3/4cmd to upload here
sync

echo `date` synced >> /share/actions.log

command="curl -X POST $CALLBACK_URL/synced/$CLIENT_TOKEN"

n=0
until [ $n -ge 10 ]
do
    $command && exit
    echo `date` "failed to report synced, retry" >> /share/actions.log
    n=$[$n+1]
done

echo `date` "failed to report synced, giving up" >> /share/actions.log
