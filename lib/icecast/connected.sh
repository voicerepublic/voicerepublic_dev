#!/bin/sh

killall liquidsoap

echo `date` connected >> /share/actions.log

COMMAND="curl -X POST $CALLBACK_URL/$CLIENT_TOKEN/connect"

N=0
until [ $N -ge 10 ]
do
    $COMMAND && exit
    N=$[$N+1]
    echo `date` "failed to report connected, retry $N" >> /share/actions.log
done

echo `date` "failed to report connected, giving up" >> /share/actions.log
