#!/bin/sh

DEFAULT=hackem

ICECAST_SOURCE_PASSWORD="${ICECAST_SOURCE_PASSWORD:-$DEFAULT}"
ICECAST_RELAY_PASSWORD="${ICECAST_RELAY_PASSWORD:-$DEFAULT}"
ICECAST_ADMIN_PASSWORD="${ICECAST_ADMIN_PASSWORD:-$DEFAULT}"
ICECAST_PASSWORD="${ICECAST_PASSWORD:-$DEFAULT}"

ICECAST_ADMIN_USER="${ICECAST_ADMIN_USER:-admin}"


# apply to template
. ./icecast.xml-template.sh > /etc/icecast2/icecast.xml

# start icecast
/usr/bin/icecast2 -c /etc/icecast2/icecast.xml &
ICECAST_PID=$!
echo Icecast start with pid $ICECAST_PID

# give icecast time to settle
sleep 3

# start live transcoder
/usr/bin/liquidsoap -v ./icebox.liq &

# send ready signal
./ready.sh

# enter stats loop, check if icecast has come to end
while kill -0 $ICECAST_PID
do
    ./stats.sh
    sleep $STATS_INTERVAL
done
