#!/bin/sh

# if we omit $ to math the end of the line everything till the end of
# the line ends up in the matchgroup #sedmagic
sed -i 's/^.*\(ssh-rsa\)/\1/' ~/.ssh/authorized_keys
