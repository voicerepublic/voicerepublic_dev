# Welcome to Audio Worker

# NEWSCHOOL

Run `lib/audio_worker/build.sh`

# OLDSCHOOL

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

### Install git, ruby, s4cmd,... & add admin to docker

```
apt-get -y install git ruby sox python-pip libsox-fmt-mp3
pip install s4cmd
chmod a+x /usr/local/bin/s4cmd

ln -s `which avconv` /usr/local/bin/ffmpeg

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
# wav2json docker

## Usage

There is a wrapper shell script in `bin/wav2json`. It will build the
docker image if nescessary. It takes the name of the wave file as the
first argument. The file has to reside in the current working
directory.

This will generate `improved_jingle.wav.json` in the same directory.
