#!/bin/bash

echo "Add the following section to your ~/.ssh/config."
echo
echo 'Host icebox'
echo '     ForwardAgent yes'
echo '     User admin'
echo '     IdentityFile ~/.ssh/phil-ffm.pem'
echo '     Hostname 35.157.47.150'
echo
echo 'Replace the ip with your current instance on EC2.'
echo
echo 'Enter to continue.'
read

echo "Activating root access..."
ssh icebox 'sudo /root/icecast/allow_root.sh'
echo "Copying files..."
scp -r lib/icebox root@icebox:
scp -r lib/ffmpeg/ root@icebox:
echo "The files have been copied to the icebox."
echo "Preparing Icebox for imaging... (This might take a while.)"
ssh root@icebox ./icebox/prepare_image.sh

echo "Finished. Next steps..."
echo
echo "1. Pull an image on EC2."
echo "2. Add the AMI key to config/settings.yml."
echo "3. Commit"
echo "4. Push"
echo "5. Deploy your branch."
echo "6. Wait for the AMI to be 'available'."
echo "7. Test it!"
echo
