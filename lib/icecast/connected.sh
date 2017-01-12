#!/bin/sh

echo `date` connected >> /share/actions.log

command="curl -X POST $CALLBACK_URL/connect/$CLIENT_TOKEN"

n=0
until [ $n -ge 10 ]
do
    $command && exit
    echo `date` "failed to report connected, retry" >> /share/actions.log
    n=$[$n+1]
done

echo `date` "failed to report connected, giving up" >> /share/actions.log
