#!/bin/sh

DEFAULT=hackem

ICECAST_SOURCE_PASSWORD="${ICECAST_SOURCE_PASSWORD:-$DEFAULT}"
ICECAST_RELAY_PASSWORD="${ICECAST_RELAY_PASSWORD:-$DEFAULT}"
ICECAST_ADMIN_PASSWORD="${ICECAST_ADMIN_PASSWORD:-$DEFAULT}"
ICECAST_PASSWORD="${ICECAST_PASSWORD:-$DEFAULT}"

ICECAST_ADMIN_USER="${ICECAST_ADMIN_USER:-admin}"


# only for debugging purposes
cat >/share/icecast-info.sh<<EOF
ICECAST_SOURCE_PASSWORD=$ICECAST_SOURCE_PASSWORD
ICECAST_RELAY_PASSWORD=$ICECAST_RELAY_PASSWORD
ICECAST_ADMIN_PASSWORD=$ICECAST_ADMIN_PASSWORD
ICECAST_PASSWORD=$ICECAST_PASSWORD
ICECAST_ADMIN_USER=$ICECAST_ADMIN_USER
EOF


# apply to template
. ./icecast.xml-template.sh > /etc/icecast2/icecast.xml

# technically this should come after starting icecast, but for now
# this is good enough
./ready.sh

# start icecast
/usr/bin/icecast2 -c /etc/icecast2/icecast.xml
