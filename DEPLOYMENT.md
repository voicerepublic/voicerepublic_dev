DEPLOYMENT NOTES
================

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

    # apt-get install vorbis-tools


Backend
-------

Should be deployed the same as the normal app, but using the user `backend`.


TODO
====

### DNS configuration for production server

### Setup localeapp

### Deploy 2nd app (backoffice) to same host or share db
