#!/bin/sh

echo `date` ready >> /share/actions.log

JSON='{"public_ip_address":"'$PUBLIC_IP'"}'

command=$(curl -X POST --data "$JSON" $CALLBACK_URL/ready/$CLIENT_TOKEN)

n=0
until [ $n -ge 10 ]
do
    $command && exit
    echo `date` "failed to report ready, retry" >> /share/actions.log
    n=$[$n+1]
done

echo `date` "failed to report ready, giving up" >> /share/actions.log
