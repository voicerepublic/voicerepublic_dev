ICECAST DOCKER SETUP
====================

1. Prerequisites
2. Setup development
3. Setup production (AWS EC2)
4. Notes


Prerequistites
--------------

### Install Docker on Debian Jessie

```
apt-get -y install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list

apt-get update

apt-get -y install docker-engine
```


Setup development
-----------------

Install Docker as described above.

```
docker build -t branch14/icecast2 lib/icecast
```


Setup production (AWS EC2)
--------------------------

These instructions are based on Debian Jessie.

Spawn an instance of Debian 8 on AWS EC2.

Locally I use an entry in my `~/.ssh/config`. E.g.

```
Host icebox
     ForwardAgent yes
     User root
     IdentityFile ~/.ssh/phil-ffm.pem
     Hostname 52.58.144.188

```

Then...


```
# login as admin
#
#   ssh admin@icebox

sudo -i

# edit/fix `~/.ssh/authorized_keys` so we can login as root

logout

# copy/scp the directory `lib/icecast` over to root
#
#   scp -r lib/icecast root@icebox:
#
# log in as root
#
#   ssh root@icebox

apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get -y install curl

# install docker as described above, then...

docker build -t branch14/icecast2 icecast/.

# install s3fs as follows...
apt-get install automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz -O s3fs.tgz
tar xfvz s3fs.tgz
cd s3fs-fuse-1.79
./autogen.sh
./configure
make
make install
cd
```

Pull an AMI. Done. Add the AMIs id to `settings.yml`.

Updating an image
-----------------

When updating an image consider updating the software...

```
apt-get update
apt-get upgrade
apt-get install docker-engine
```

Maybe also update s3fs.

Then rebuild the docker image...

```
docker build -t branch14/icecast2 icecast/.
```

Before pulling the AMI make sure you stop and remove the current docker instance.

```
docker stop icecast
docker rm icecast
```

Now pull the AMI via [AWS Console](https://eu-central-1.console.aws.amazon.com/ec2/v2/home?region=eu-central-1#Instances:instanceState=running).


Notes on Working on the image
-----------------------------

```
scp -r lib/icecast root@icebox:
```

```
export VENUE_SLUG=<your venue's slug>

docker stop icecast
docker rm icecast
docker build -t branch14/icecast2 icecast/.
docker run --detach=true --name=icecast --env-file=/root/env.list --expose=8000 --publish=80:8000 --volume=/data/$VENUE_SLUG:/share branch14/icecast2

```

Other helpful commands

* `docker restart icecast`
* `docker exec -ti icecast bash`

### cleanup when creating a new image

```
docker stop icecast
docker rm icecast
docker build -t branch14/icecast2 icecast/.
rm /etc/passwd-s3fs
rm /root/env.list
rm /tmp/part-001.log
rm /var/lib/cloud/instance/scripts/part-001

```

More Notes
----------

```
docker stop icecast
docker rm icecast

apt-get -y install ruby ruby-dev

( cd icecast_setup
  git add .
  git commit -m 'update'
  git pull && git pull )
```

* AWS Security Group `sg-b7d058d0` (Icecast Servers)
* Debian jessie amd64
* Type `t2.micro`

`sudo docker exec -i -t icecast /bin/bash`

### Statistics

* curl -u admin:mqilkfut http://52.58.132.102/admin/stats.xml
* curl http://52.58.132.102/status-json.xsl

* curl http://localhost:8000/status-json.xsl | curl -X POST -d @- $CALLBACK_URL/stats/$CLIENT_TOKEN

### Resources

* http://stackoverflow.com/questions/5004159/opening-port-80-ec2-amazon-web-services
* https://forum.sourcefabric.org/discussion/13883/icecast-on-port-80/p1
