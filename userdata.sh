#!/bin/bash -x

# on ec2 this file can be found in
# /var/lib/cloud/instance/scripts/part-001

# this redirect everything to a log
exec > /tmp/part-001.log 2>&1

STORAGE=/tmp/recordings
PREFIX=default-venue-12707101-e1ec-43d8-b159-e4cdf501286a

mkdir -p $STORAGE

if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then

  PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

  HOME=/root

  # mount the bucket
  BUCKET=
  AWS_CREDENTIALS=:

  echo $AWS_CREDENTIALS > /etc/passwd-s3fs
  chmod 600 /etc/passwd-s3fs
  /usr/local/bin/s3fs $BUCKET $STORAGE -o allow_other
else

  PUBLIC_IP=`hostname -I | cut -d ' ' -f 1`
fi

mkdir -p $STORAGE/$PREFIX
chmod 777 $STORAGE/$PREFIX

ENV_LIST=$HOME/env.list

cat >$ENV_LIST <<EOF
ICECAST_SOURCE_PASSWORD=aomtbjxp
ICECAST_ADMIN_PASSWORD=doaebcut
ICECAST_LIMIT_SOURCES=2

CALLBACK_URL=http://10.0.2.15:3000/icecast
CLIENT_TOKEN=default-venue-12707101-e1ec-43d8-b159-e4cdf50128-1463064251-ivox

PUBLIC_IP=$PUBLIC_IP
EOF

docker run \
       --detach=true \
       --name=icecast \
       --env-file=$ENV_LIST \
       --expose=8000 \
       --publish=8000:8000 \
       --restart=unless-stopped \
       --volume=$STORAGE/$PREFIX:/share \
       branch14/icecast2


# callback to slack -- for debugging only
CLIENT_TOKEN=default-venue-12707101-e1ec-43d8-b159-e4cdf50128-1463064251-ivox
TEXT="Started Icebox on $PUBLIC_IP with client token $CLIENT_TOKEN"
JSON='{"channel":"@phil","text":"'$TEXT'","icon_emoji":":mushroom:","username":"icecast"}'

curl -X POST -H 'Content-type: application/json' --data "$JSON" \
     https://hooks.slack.com/services/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


# --- cleanup when creating a new image
# docker stop icecast
# docker rm icecast
# rm /etc/passwd-s3fs
# rm /etc/env.list
# rm /tmp/part-001.log
