#!/bin/sh

echo `date` connected >> /share/actions.log

# TODO start transcoders & write pid files
echo `date` start transcoders `pwd` >> /share/actions.log
./transcode.sh mp3 $ICECAST_SOURCE_PASSWORD &
echo -n $! > /share/transcode_mp3.pid
./transcode.sh ogg $ICECAST_SOURCE_PASSWORD &
echo -n $! > /share/transcode_ogg.pid
./transcode.sh aac $ICECAST_SOURCE_PASSWORD &
echo -n $! > /share/transcode_aac.pid

COMMAND="curl -X POST $CALLBACK_URL/connect/$CLIENT_TOKEN"

N=0
until [ $N -ge 10 ]
do
    $COMMAND && exit
    N=$[$N+1]
    echo `date` "failed to report connected, retry $N" >> /share/actions.log
done

echo `date` "failed to report connected, giving up" >> /share/actions.log
