#!/bin/bash

echo 'deb http://ftp.debian.org/debian jessie-backports main' > \
     /etc/apt/sources.list.d/backports.list

apt-get update

apt-get install -y git

# auto login
mkdir -p /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin vagrant --noclear %I \$TERM
EOF

apt-get install -y zsh i3

# auto start x
echo '[ "$(tty)" = "/dev/tty1" ] && exec startx' >> ~vagrant/.zprofile
