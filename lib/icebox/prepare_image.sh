#!/bin/sh

docker stop icecast
docker rm icecast
docker build -t branch14/icecast2 ~/icecast/.
rm -f /etc/passwd-s3fs
rm -f /root/env.list
rm -f /tmp/part-001.log
rm -rf /var/lib/cloud/*

echo
echo 'System prepared for imaging.'
echo
