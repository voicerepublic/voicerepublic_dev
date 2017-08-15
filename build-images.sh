#!/bin/bash
# ------------------------------------------------------------------
# [Josef Erben] Docker Image Builder for Voicerepublic
# ------------------------------------------------------------------

VERSION=0.0.2
USAGE="build-images.sh"

ssh_location="/home/josef/.ssh"

# Clean up, temporary network creation
docker network create --driver=bridge buildnetwork
docker stop vault && docker rm vault

# Creates a secret provider in the 'buildnetwork' network
docker run --name vault --network=buildnetwork -p 14242:3000 -v "$ssh_location":/vault/.ssh -d dockito/vault  

# Actual image building
docker build -t vr/dev --network=buildnetwork .

# Clean up
docker stop vault && docker rm vault
docker network rm buildnetwork
