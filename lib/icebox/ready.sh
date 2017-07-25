#!/bin/sh

echo `date` ready >> /share/actions.log

JSON='{"public_ip_address":"'$PUBLIC_IP'"}'

COMMAND="curl -X POST --data $JSON $CALLBACK_URL/$CLIENT_TOKEN/ready"

N=0
until [ $N -ge 10 ]
do
    $COMMAND && exit
    N=$[$N+1]
    echo `date` "failed to report ready, retry $N" >> /share/actions.log
done

echo `date` "failed to report ready, giving up" >> /share/actions.log
