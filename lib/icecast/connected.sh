#!/bin/sh

echo `date` connected >> /share/actions.log

COMMAND="curl -X POST $CALLBACK_URL/connect/$CLIENT_TOKEN"

N=0
until [ $N -ge 10 ]
do
    $COMMAND && exit
    N=$[$N+1]
    echo `date` "failed to report connected, retry $N" >> /share/actions.log
done

echo `date` "failed to report connected, giving up" >> /share/actions.log
