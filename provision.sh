#!/bin/bash

echo 'deb http://ftp.debian.org/debian jessie-backports main' > \
     /etc/apt/sources.list.d/backports.list

apt-get update

apt-get install -y zsh i3 xinit roxterm git

# auto login
mkdir -p /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin vagrant --noclear %I \$TERM
EOF

# zsh
chsh -s /usr/bin/zsh vagrant

cat >~vagrant/.zprofile <<EOF
autoload -Uz compinit promptinit
compinit
promptinit
prompt walters
EOF

# auto start x
echo '[ "$(tty)" = "/dev/tty1" ] && exec startx' >> ~vagrant/.zprofile


# setup vr
mkdir -p ~vagrant/src
ln -s /vagrant ~vagrant/src/vr

chown -R vagrant: ~vagrant

# TODO
su -c 'ssh-keygen -b 2048 -t rsa -f .ssh/id_rsa -N ""'
echo '=== IMPORT THIS KEY TO GITHUB ==='
echo
cat ~vagrant/.ssh/id_rsa.pub
echo
echo '==='
