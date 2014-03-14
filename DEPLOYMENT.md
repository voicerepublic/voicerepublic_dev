DEPLOYMENT NOTES
================

Components Overview
-------------------

* rails app
* multiple djs for separate queues
* rtmpd (nginx)
* private_pub (faye)
* localeapp


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
    [13:59:25] voicerepublic-staging:~$ psql rails_production
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


Requirements
------------

* postgresql-contrib-9.1
* libpcre++-dev
* libav-tools
* sox


Nice to have
------------

* tree
* multitail
