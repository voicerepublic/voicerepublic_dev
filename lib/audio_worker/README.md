# Welcome to Audio Worker

## Setup

### Development

Just build the docker image by running

    lib/audio_worker/build.sh

### Production

You need to set up Development first! (As this will pull the fidelity
repo which will then be copied to the ec2 instance.)

Spawn an ec2 instance with Debian Jessie. Get the IP and make an entry
in `~/.ssh/config`

```
Host vrw
     User admin
     IdentityFile ~/.ssh/phil-ffm.pem
     Hostname 52.59.100.12
```

Then copy some files over

    scp -r lib/audio_worker vrw:

Login in & become root

    ssh vrw

	sudo -i

Then install docker, build docker image & add user to group docker

```
~admin/audio_worker/install_docker.sh
docker build -t branch14/audio_worker ~admin/audio_worker
adduser admin docker
```

(TODO Check: ading to group docker might not be needed as cloud-init
will run the docker container as root.)

Done.

Pull an AMI, add reference to AMI to `settings.yml`, deploy, test.

## Cheat Sheet

```
sudo -i
cat /var/lib/cloud/instance/user-data.txt
ls /tmp/run.sh.*
ls -la /var/log/cloud-init*
```
