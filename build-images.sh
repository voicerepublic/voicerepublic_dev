#!/bin/bash
# ------------------------------------------------------------------
# [Josef Erben] Docker Image Builder for Voicerepublic
# ------------------------------------------------------------------

VERSION=0.0.1
SUBJECT=some-unique-id
USAGE="Usage: command -ihv args"

docker run --name vault -p 172.17.0.1:14242:3000 -v ~/.ssh:/vault/.ssh dockito/vault &
docker build -t vr/dev .
docker stop vault 
