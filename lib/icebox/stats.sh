#!/bin/sh

# this is fire and forget, if it is lost, no big deal
curl http://localhost:8080/status-json.xsl | \
    jq -c ".uptime=\"`uptime -s`\"|.load=\"`cat /proc/loadavg`\"" | \
    curl -X POST -d @- $CALLBACK_URL/$CLIENT_TOKEN/stats
