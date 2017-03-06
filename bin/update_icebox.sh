#!/bin/bash

echo "Add the following section to your `~/.ssh/config`."
echo
echo Host icebox
echo      ForwardAgent yes
echo      User admin
echo      IdentityFile ~/.ssh/phil-ffm.pem
echo      Hostname 35.157.47.150
echo
echo Replace the ip with your current instance on EC2.
echo
echo Any key to continue.
read

echo "Activating root access..."
ssh icebox 'sudo /root/icecast/allow_root.sh'
echo "Copying files..."
scp -r lib/icecast root@icebox:
echo "The files have been copied to the icebox."
echo "Preparing Icebox for imaging... (This might take a while.)"
ssh root@icebox ./icecast/prepare_image.sh

echo "Finished."
echo "Now pull an image on EC2."
echo
echo "Then add the AMI key to `config/settings.yml`."
echo "Commit, Push, Deploy & Test it!"
echo
