# Welcome to Audio Worker

## Setup

Assuming your host is called `vrw`, as in the following ssh config

```
Host vrw
     User admin
     IdentityFile ~/.ssh/phil-ffm.pem
     Hostname 52.59.100.12
     ForwardAgent yes
```

### Copy some files over

```
scp -r lib/wav2json vrw:
scp -r lib/audio_worker vrw:
```

### Log in

```
ssh vrw
```

### Install docker

Become root

`sudo -i`

Then

```
apt-get -y install apt-transport-https ca-certificates

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo 'deb https://apt.dockerproject.org/repo debian-jessie main' > /etc/apt/sources.list.d/docker.list

apt-get update

apt-get -y install docker-engine psmisc
```

### Install git, ruby, s3fs,... & add admin to docker

```
apt-get -y install git ruby sox python-pip

pip install s4cmd

# OBSOLETE
# apt-get -y install automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config fuse
# wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz -O s3fs.tgz
# tar xfvz s3fs.tgz
# cd s3fs-fuse-1.79
# ./autogen.sh
# ./configure
# make
# make install
# cd

adduser admin docker
```

Log out of the root shell (`Ctrl-d`)

### Install fidelity

```
git clone git@github.com:munen/fidelity.git

sudo docker build -t branch14/fidelity fidelity
```

### Setup wav2json

```
sudo docker build -t branch14/wav2json wav2json
```

### Setup ruby

```
sudo gem install bundler --no-ri --no-rdoc
(cd audio_worker && bundle install)
```
