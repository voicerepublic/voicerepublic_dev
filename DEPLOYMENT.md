DEPLOYMENT NOTES
================

cdist
-----

### Install OSX

    brew install python3
    sudo pip3 install cdist

### Configure host

See the `README` in the voicerepublic_dot_cdist repo:
    https://bitbucket.org/voicerepublic/voicerepublic_dot_cdist/


Issue 'missing ruby' -- Resolved
--------------------------------

As user `app`

    app@voicerepublic-production:~$ rbenv global 1.9.3-p448
    rbenv: version `1.9.3-p448' not installed

Solution:

    $ rbenv install 1.9.3-p448

Issue 'missing bundler' -- Resolved
-----------------------------------

As user `app`

    app@voicerepublic-staging:~$ rbenv versions
      1.9.3-p448
    app@voicerepublic-staging:~$ bundle
    -bash: bundle: command not found
    app@voicerepublic-staging:~$ gem
    rbenv: gem: command not found

    The `gem' command exists in these Ruby versions:
      1.9.3-p448
    app@voicerepublic-staging:~$ rbenv global 1.9.3-p448
    app@voicerepublic-staging:~$ rbenv versions
    * 1.9.3-p448 (set by /home/app/.rbenv/version)
    app@voicerepublic-staging:~$ gem install bundler
    Fetching: bundler-1.5.3.gem (100%)
    Successfully installed bundler-1.5.3
    1 gem installed
    Installing ri documentation for bundler-1.5.3...
    Installing RDoc documentation for bundler-1.5.3...
    app@voicerepublic-staging:~$ echo 'gem: --no-document' > .gemrc


Issue 'missing packages' -- Resolved
------------------------------------

As root

    [13:05:41] voicerepublic-staging:~# apt-get install postgresql-contrib-9.1 libpcre++-dev libav-tools
    ...


Issue 'PG::InsufficientPrivilege' -- Resolved
---------------------------------------------

As root

    [13:59:18] voicerepublic-staging:~# su - postgres
    [13:59:18] voicerepublic-staging:~$ psql rails_production
    psql (9.1.11)
    Type "help" for help.

    rails_production=# CREATE EXTENSION pg_trgm;
    CREATE EXTENSION
    rails_production=# CREATE EXTENSION unaccent;
    CREATE EXTENSION


Build & start rtmpd
-------------------

    app@voicerepublic-staging:~$ current
    app@voicerepublic-staging:~/app/current$ be rake rtmp:build
    created directory /home/app/app/shared/rtmp
    checking for nginx...
    fetching newest version (nginx-1.5.11)...
    checking for nginx-rtmp-module...
    fetching newest version (v1.1.3)...
    compiling (nginx-1.5.11/nginx-rtmp-module-1.1.3)...

    Good news everyone. You're all set.

      rake rtmp:(start|stop|restart)

    app@voicerepublic-staging:~/app/current$ be rake rtmp:start
    rtmpd started with pids 4199, 4200, 4201


Setup symlinks
--------------

    app@voicerepublic-staging:~/app/current$ be rake setup
    RECORDINGS /home/app/app/shared/recordings
    Create /home/app/app/shared/recordings
    RTMPBUILD  /home/app/app/shared/rtmp
    RECTEMP    /home/app/app/shared/rtmp/run/recordings
    symlink    /home/app/app/shared/rtmp/run/recordings
         ->    /home/app/app/shared/recordings


PrivatePub Config
-----------------

    app@voicerepublic-staging:~$ cp app/current/config/private_pub.yml app/shared/config/private_pub.yml
    app@voicerepublic-staging:~$ nano app/shared/config/private_pub.yml
    app@voicerepublic-staging:~$ cat app/shared/config/private_pub.yml
    production:
      server: "http://voicerepublic-staging.sky.ungleich.ch:9292/faye"
      secret_token: "1ca35552f8b33e95302a951002a835fc39b6699ab2447f9140d36190fca0c0a7"
      signature_expiration: 7200 # two hours


Installed monit, tree & multitail
---------------------------------

    # apt-get install monit tree multitail


Fixed Monit Setup
-----------------

* copied developer-monit from here https://github.com/munen/voicerepublic_dot_cdist/blob/master/type/__panter_monit/files/config/developer-monit
* fixed it
* updated https://github.com/munen/voicerepublic_dot_cdist/blob/master/type/__panter_monit/files/config/developer-monit
* put the above file into `/etc/monit/conf.d/developer-monit`
* enabled web interface in `/etc/monit/monitrc`

For the applications monit setup, checkout [monit.conf](config/monit.conf)


Changed NGINX Config to allow bigger uploads
--------------------------------------------

Added this line to `/etc/nginx/sites-enabled/default`

    client_max_body_size 20m;

(this has been ported to cdist as of 2014-04-03)


Configured portfilter (Nico)
----------------------------

### Now Open

* 9292 (private_pub/faye)
* 1935 (rtmp)

(in cdist)

Installed missing package
-------------------------

    # apt-get install vorbis-tools lame

Installed package
-----------------

    s3cmd


Create flyer
------------

  * aptitude install inkscape
  * Install otf fonts in app user home directory

    ➜  ~  ls .fonts
    Eagle-Book.otf  Eagle-Light.otf


BackOffice (aka. Backend)
-------------------------

Should be deployed the same as the normal app, but using the user `backend`.

Additionally I had to install `patch` (since nokogiri sometimes relies on it during install)

    apt-get install patch


Image Upload Directory Permissions
----------------------------------

Both the normal `app` and `backend` currently share uploaded images under
`/home/app/app/shared/public/system/dragonfly/` that directory needs to be
set up correctly:

    drwxrwsr-x 3 app imageupload  4096 Apr  7 09:41 dragonfly

According to Munen the plan is move uploaded images off to S3, after which
this becomes moot. In that case please delete the respective code in cdist:
https://github.com/munen/voicerepublic_dot_cdist/commit/b821a7d447782f87af2885cd78ab7408ab2375d4


Munin Plugins
-------------

As root

    apt-get install libxml-xpath-perl
    cd /etc/munin/plugins
    ln -s /home/app/app/current/bin/munin/rtmp
    ln -s /home/app/app/current/bin/munin/raindrops
    ln -s /home/app/app/current/bin/munin/du_ du_home_app_shared_recordings

    ln -s /usr/share/munin/plugins/port_ port_1935
    ln -s /usr/share/munin/plugins/port_ port_9292
    ln -s /usr/share/munin/plugins/postgres_querylength_  postgres_querylength_ALL
    ln -s /usr/share/munin/plugins/postgres_xlog

CI
==

## PhantomJS

For CI we need phantomjs. On wheezy there is no package for that yet. However,
there are precompiled binaries here: http://phantomjs.org/download.html

It was downloaded and installed into
/usr/local/bin/phantomjs-1.9.7-linux-x86_64/bin/

In sid, there is a package, already. When upgrading to sid, we should install
via package management.

phantomjs executable made available to path as described here:
https://github.com/munen/voicerepublic_dot_cdist/pull/7

and

    cd bin; ln -s /usr/local/bin/phantomjs-1.9.7-linux-x86_64/bin/phantomjs

## Chromium

1. Install the chromium debian package.

    [15:33:18] voicerepublic-staging:~# aptitude install chromium
    The following NEW packages will be installed:
      chromium chromium-inspector{a} libdrm-intel1{a} libdrm-nouveau1a{a} libdrm-radeon1{a} libdrm2{a}
      libfile-basedir-perl{a} libfile-desktopentry-perl{a} libfile-mimeinfo-perl{a} libfontenc1{a}
      libgl1-mesa-dri{a} libgl1-mesa-glx{a} libglapi-mesa{a} libgnome-keyring-common{a}
      libgnome-keyring0{a} libnet-dbus-perl{a} libnspr4{a} libnss3{a} libpciaccess0{a} libspeechd2{a}
      libtie-ixhash-perl{a} libx11-protocol-perl{a} libxcb-glx0{a} libxcb-shape0{a} libxml-twig-perl{a}
      libxmuu1{a} libxss1{a} libxv1{a} libxxf86dga1{a} libxxf86vm1{a} x11-utils{a} x11-xserver-utils{a}
      xdg-utils{a}

1. Install xvfb (X Virtual Framebuffer)

   With this, we can run Firefox and Chromium headlessly:

     Xvfb :1 -screen 0 1024x768x24+32

    The following extra packages will be installed:
      libaudit0 libxfont1 libxkbfile1 x11-xkb-utils xfonts-base xfonts-encodings xfonts-utils xkb-data
      xserver-common

1. Install chromedriver binary to /usr/local/bin

1. (Install the iceweasel debian package.)
   We currently do not use Firefox in any request spec. So this step can be
   left out.

1. Install xauth debian package to be able to ssh -X into the machine and do
   some manual debugging.


## Fix ci migrations on staging

    (cd app/shared/ci && bundle && bin/rake db:migrate RAILS_ENV=test)

## Additional dependencies

    apt-get install libsox-fmt-mp3


Update Ruby
===========

Keep track of new ruby versions

    cd ~/.rbenv/plugins/ruby-build
    git pull
    cd

List all available

    rbenv install --list

Build a specific

    rbenv install 2.1.2

After install a new version also

    rbenv global 2.1.2
    gem install bundler


2015-06-09 Setup RabbitMQ Server
================================

DO NOT DO IT LIKE THIS! DO IT LIKE DESCRIBED IN `doc/ELK.md`.

    apt-get install rabbitmq-server
    rabbitmq-plugins enable rabbitmq_management
    /etc/init.d/rabbitmq-server restart

2015-06-30 Configure Logrotate
==============================

Add `notifempty` to `/etc/logrotate.d/rails-app`.


TODO
====

### DNS configuration for production server

### Setup localeapp

### Deploy 2nd app (backoffice) to same host or share db

2017-10-10 Cronjob to store Nginx logs on S3
============================================

The S3 bucket vr-euc1-live-misc has been created with `rake fog:setup`.

```
cat bin/sync-logs-to-s3.sh
#!/bin/bash

aws s3 sync /var/log/nginx/ s3://vr-euc1-live-misc/var/log/nginx/ && \
  rm /var/log/nginx/*.gz

crontab -l
0 3 * * * /root/bin/sync-logs-to-s3.sh

cat .aws/credentials
[default]
aws_secret_access_key = ''
aws_access_key_id = ''
region = eu-central-1
s3 =
    signature_version = s3v4
```

2017-10-12 Moved Postregs to Home
=================================

```
mkdir -p /home/postgres/9.1/main
chown -R postgres: /home/postgres/
rsync -av /var/lib/postgresql/9.1/main/ /home/postgres/9.1/main

sed -i.bak 's|/var/lib/postgresql/9.1/main|/home/postgres/9.1/main|' /etc/postgresql/9.1/main/postgresql.conf

diff /etc/postgresql/9.1/main/postgresql.conf /etc/postgresql/9.1/main/postgresql.conf.bak

# stop all services (unicorn, backoffice, djs)

/etc/init.d/postgresql stop
rsync -av /var/lib/postgresql/9.1/main/ /home/postgres/9.1/main
/etc/init.d/postgresql start

# start all services
```

2017-10-18 Change Munin Configuration
=====================================

```
rm /etc/munin/plugins/port_1935
rm /etc/munin/plugins/du_home_app_app_shared_recordings
rm /etc/munin/plugins/rtmp

ln -s /home/app/app/current/bin/munin/du_ /etc/munin/plugins/du_tmp
ln -s /home/app/app/current/bin/munin/du_ /etc/munin/plugins/du_home_postgres

/etc/init.d/munin-node restart
```

2017-10-18 Cronjob to remove imagemagick leftovers from /tmp
============================================================

```
$ chmod a+x bin/cleanup-imagemagick-turds.sh
$ cat bin/cleanup-imagemagick-turds.sh
#!/bin/sh

find /tmp -name magick-\*.pam -mmin +60 -delete
```

```
$ crontab -l
0 * * * * /root/bin/cleanup-imagemagick-turds.sh
```

2017-10-18 Cronjob to store Rails logs on S3
============================================

```
cat /home/app/bin/sync-logs-to-s3.sh
#!/bin/bash

aws s3 sync /home/app/app/shared/log/ s3://vr-euc1-live-misc/home/app/app/shared/log/ && \
  rm /home/app/app/shared/log/*.gz

crontab -l
5 3 * * * /home/app/bin/sync-logs-to-s3.sh

cat .aws/credentials
[default]
aws_secret_access_key = ''
aws_access_key_id = ''
region = eu-central-1
s3 =
    signature_version = s3v4
```
