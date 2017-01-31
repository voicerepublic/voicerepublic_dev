#!/bin/sh

# this is fire and forget, if it is lost, no big deal
curl http://localhost:8000/status-json.xsl | \
    curl -X POST -d @- $CALLBACK_URL/stats/$CLIENT_TOKEN
