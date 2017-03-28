#!/bin/bash

echo 'deb http://ftp.debian.org/debian jessie-backports main' > \
     /etc/apt/sources.list.d/backports.list

apt-get update

apt-get install -y git

mkdir -p /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin vagrant --noclear %I \$TERM
EOF
