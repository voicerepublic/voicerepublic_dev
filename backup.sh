#!/bin/bash -x

# on ec2 this file can be found in
# /var/lib/cloud/instance/scripts/part-001
# now seems to have moved to
# /var/lib/cloud/instance/user-data.txt

# http://stackoverflow.com/questions/27086639/user-data-scripts-is-not-running-on-my-custom-ami-but-working-in-standard-amazo

# this redirects everything to a log
#exec > /tmp/part-001.log 2>&1

STORAGE=/tmp/recordings
PREFIX=venue-of-walter-white

mkdir -p $STORAGE

if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then

  PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

  HOME=/root

  cat >> /home/admin/.ssh/authorized_keys<<EOF

EOF

else

  PUBLIC_IP=`hostname -I | cut -d ' ' -f 1`
fi

mkdir -p $STORAGE/$PREFIX
chmod 777 $STORAGE/$PREFIX

# generate a new self signed key which is valid for 2 days
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
        -keyout $STORAGE/$PREFIX/icecast.pem \
        -out $STORAGE/$PREFIX/icecast.pem \
        -subj "/C=CH/ST=Zurich/L=Zurich/O=Voice Republic Media AG/OU=R&D/CN=voicerepublic.com"

ENV_LIST=$HOME/env.list

cat >$ENV_LIST <<EOF
ICECAST_SOURCE_PASSWORD=qfypmnzd
ICECAST_ADMIN_PASSWORD=izmaecfu
ICECAST_LIMIT_SOURCES=12

CALLBACK_URL=http://dev:3000/icebox
TRANSCODING_SCRIPT_URL=
CLIENT_TOKEN=venue-of-walter-white-1502205750-imuy

STATS_INTERVAL=4

AWS_STORAGE=s3://vr-euc1-dev-recordings/venue-of-walter-white/
AWS_ACCESS_KEY=AKIAIGKSA6ESEFZV4DQA
AWS_SECRET_KEY=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
AWS_REGION=eu-central-1

PUBLIC_IP=$PUBLIC_IP
EOF

if [ "$(docker ps -q -f name=icecast)" ]; then
    docker rm icecast
fi

# production
#docker run \
#       --detach=true \
#       --name=icecast \
#       --env-file=$ENV_LIST \
#       --publish=80:8080 \
#       --publish=443:8443 \
#       --restart=unless-stopped \
#       --volume=$STORAGE/$PREFIX:/share \
#       branch14/icecast2

# in dev this helps
#
 docker stop icecast
 docker rm icecast
 docker run \
	--network=voicerepublicdev_network \
        --name=icecast \
        --env-file=$ENV_LIST \
        --publish=80:8080 \
        --volume=$STORAGE/$PREFIX:/share \
        branch14/icecast2


# callback to slack -- for debugging only
# CLIENT_TOKEN=venue-of-walter-white-1502205750-imuy
# TEXT="Started Icebox on $PUBLIC_IP with client token $CLIENT_TOKEN"
# JSON='{"channel":"@phil","text":"'$TEXT'","icon_emoji":":mushroom:","username":"icecast"}'
#
# curl -X POST -H 'Content-type: application/json' --data "$JSON" \
#      https://hooks.slack.com/services/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
