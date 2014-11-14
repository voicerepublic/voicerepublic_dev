Welcome to VoiceRepublic
========================

![One does not simply...](http://www.memecreator.org/static/images/memes/809494.jpg)

"Work is the curse of the drinking classes." -- Gentleman Rhymer

### Build status

* Integration: [![Build Status](https://circleci.com/gh/munen/voicerepublic_dev/tree/develop.png?circle-token=8ebbe8b002c7556614695f94dd6bd0e92ec532de
)](https://circleci.com/gh/munen/KluuU/tree/integration)
* Master: [![Build Status](https://circleci.com/gh/munen/voicerepublic_dev/tree/master.png?circle-token=8ebbe8b002c7556614695f94dd6bd0e92ec532de
)](https://circleci.com/gh/munen/KluuU/tree/master)

### Code Quality

* Develop: [![Code Climate](https://codeclimate.com/repos/52d695526956802e2600897b/badges/d72650afa4aea3392af9/gpa.png)](https://codeclimate.com/repos/52d695526956802e2600897b/feed)

### Platforms

* Live: [http://voicerepublic.com](http://voicerepublic.com)
* Staging: [http://staging.voicerepublic.com](http://staging.voicerepublic.com)


Dependencies
------------

### Ruby

VR is being developed on Ruby 2.1.2. See [.ruby-version](.ruby-version).

The use of [rbenv](https://github.com/sstephenson/rbenv)
and [ruby-build](https://github.com/sstephenson/ruby-build) instead of
RVM is highly recommended.

#### Upgrade with rbenv

    (cd ~/.rbenv && git pull)
    (cd ~/.rbenv/plugins/ruby-build && git pull)
    rbenv install 2.1.2
    gem install bundler

### Debian Packages

* postgresql-contrib-9.1
* libpcre++-dev
* libav-tools
* sox
* vorbis-tools
* libreadline-dev
* libpq-dev

make sure you install those before you proceed to the next point, since some
(-dev) packages are needed in the following steps.


### Install rbenv on zsh

    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    . ~/.zshrc
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    rbenv install `cat .ruby-version`

rbenv will install shim executables that understand rbenv settings. However
you will face the problem, that your shell remembers the location of
executables you have allready used. So before you use an executable
that should be aware of rbenv you'll either need to launch a new shell
or delete your shell's idea of where the executable is with:

    hash -r some_executable

This is namely the case with `bundle` and `cap`.

Now install bundler and capistrano versions for the chosen ruby version:

    gem install bundler
    gem install capistrano

Now start a new shell or issue

    hash -r bundle


Setup
-----

    bundle
    cp config/database.yml.example \
       config/database.yml             # use an appropriate db config
    rake db:setup                      # this requires an internet connection, also
                                       # [also see note below]
    rake db:migrate                    # also requires an internet connection
    rake rtmp:build
    rake setup

Above the step `rake db:setup` probably fails, if the connecting user in database.yml
doesn't have 'superuser' rights when connecting to the psql server. So you might want
to replace that step by:

    $ sudo su
    # su - postgres
    $ psql
    postgres=# create database vr_development owner your_db_user;


### New Search

Make sure `postgresql-contrib-9.1` is installed.

    zeus start

and in a different window:

    zeus rake pg_search:multisearch:rebuild\[Talk\]
    zeus rake pg_search:multisearch:rebuild\[Venue\]
    zeus rake pg_search:multisearch:rebuild\[User\]

### Create Postgres Extensions

    # su - postgres
    $ psql vr_development
    vr_development=# CREATE EXTENSION pg_trgm;
    CREATE EXTENSION
    vr_development=# CREATE EXTENSION unaccent;
    CREATE EXTENSION

Repeat for vr_test

### nginx/rtmp server (Debian 7 & optional)

Make sure `libpcre++-dev` is installed. Run `rake rtmp:build`. The
config file is located here `config/rtmp.conf.erb`. See
`lib/tasks/rtmp.rake` for more details.


Run App
-------

### voicerepublic_dev

* sudo apt-get install tmux
* bin/start_everything_in_tmux

### voicerepublic_backoffice

* `zeus start`
* `zeus server -p 3001`


Run Specs
---------

Install phantomjs (globaly)

    sudo npm install -g phantomjs

Run Rspec with Zeus

    zeus start
    zeus rspec spec

### Run Jasmine specs for Angular with Karma

    sudo npm install -g karma
    sudo npm install -g karma-ng-scenario
    sudo npm install -g coffee-script --save-dev
    karma start spec/javascripts/livepage.conf.js.coffee


Compile Flash
-------------

Install Flex

    http://www.adobe.com/devnet/flex/flex-sdk-download.html

Unpack and make `bin` available in your PATH.

Run

    zeus rake build:flash


Run Audio Strategies
--------------------

See [fidelity](/munen/fidelity) for details.


Documentation
-------------

For general platform and development documentation please refer to the
[GitHub wiki pages](https://github.com/munen/voicerepublic_dev/wiki).

### Build diagrams

    railroady -M | dot -Tsvg > doc/models_complete.svg
    railroady -b -M | dot -Tsvg > doc/models_brief.svg
    railroady -C | dot -Tsvg > doc/controllers_complete.svg
    railroady -b -C | dot -Tsvg > doc/controllers_brief.svg


### Working with Settings

Config entries are compiled from:

    config/settings.yml
    config/settings/#{environment}.yml
    config/environments/#{environment}.yml

    config/settings.local.yml
    config/settings/#{environment}.local.yml
    config/environments/#{environment}.local.yml

Settings defined in files that are lower in the list override settings higher.


Deploy
------

Deploying requires the presence of the ssh agent (because credentials will be
forwarded to the target machine). So make sure, you have done a:

    ssh-add

before you continue with:

    cap staging deploy

Deploy a specific branch to staging, e.g.

    REVISION=feature/65463494/subscribe_podcast cap staging deploy


HOWTO Manual Acceptance Tests (UAT)
-----------------------------------

If you don't have it already you realy should install `tree`.

    % sudo apt-get install tree

Start a local rtmp server.

    % zeus rake rtmp:start

Configure Rails to use the local rtmp server. Create a file
`config/settings.local.yml` with the following content. This will
override the configuration in `config/settings.yml`.

    rtmp:
      record: "rtmp://localhost/record"

Open two browser windows (with different sessions, one should be the
host) and direct them to show the same talk. In a terminal start
`vrwatch`. Attention: This will delete all previous recordings! (Never
ever run this in production!)

    % bin/vr_delete_and_watch

On a rails console, pick the talk you want to work with (e.g. id 42)
and reset it to start soon, there is a nifty helper for that.

    t = Talk.find(42); nil
    t.reload.make_it_start_soon!

This will also trigger a reload of the browsers. It will record a
couple of seconds pretalk. You should see the file size in 'watch'
console go up. After the time to start is up it will switch to live
mode automatically. With your second browser you should hear yourself
now. If you don't have a headset plugged in this will very likely
create a feedback loop. (Reload the host at least once if you want to
have multiple files. These will show up on the 'watch' console.)

Click `End Talk` to end the talk. On the rails console kick off post
processing (in User Acceptance Test mode) with:

    t.reload.send(:postprocess!, true)

Views will change. A journal file shows up in the 'watch'
console. When running with parameter `true` a `debugger` statement
will hold before each Audio::Strategy to inspect the precondition and
outcome in `vrwatch`. Type `c` and `Enter` to continue to the next
strategy. It will output the shell-out-commands prefixed with
`CmdRunner>`, any errors and in red the next strategy to run. (At this
point you can run the shell-out-commands under `local/recordings` to
play with them and tweak stuff.)

After the last strategy post processing will move the files from
`recordings` to `archive` resp. `archive_raw`. It'll also create
symlinks to access these files via `public/system/audio`.

At that point the history of you rails console will be dead -- no clue
why. But you can simply quit the console and restart it to get it back.

Restart `vrwatch` to remove the artifacts and start over.


Troubleshooting Process/Monit
-----------------------------

### Start processes manually

    $ current
    $ be bin/init/private_pub start
    ...
    $ be bin/init/localeapp start
    ...

### Restart Monit to make it reinitialize the flags

    # /etc/init.d/monit restart
    ...


Audio Cheat Sheet
-----------------

### For experimenting you might want to...

    sudo apt-get install libsox-fmt-mp3

### get duration

    soxi -D file.wav

### convert wav to flv

    avconv -y -i file.wav -acodec libspeex -ar 16k -ac 1 file.flv

### Make the best out of files which have silence at the beginning

    sox --norm 90.mp3 90.wav
    sox 90.wav 90-vad.wav vad

### convert x.wav to x.ogg

    oggenc x.wav

### convert x.wav to x.mp3

    avconv -y -i x.wav x.mp3

### convert x.wav to x.m4a

    avconv -y -i x.wav -b:a 64k -strict experimental x.m4a

### resample wav to 44.1k and 2 channels

    sox -c 2 vrs.wav lib/audio/files/vr_stop.wav rate -L 44.1k

### collect stream info of multiple flv files

    find ./ -name \*.flv -exec avconv -i {} \; 2>&1 | grep Stream

### List all codec of avconv

    avconv -codecs

#### Here are the relevant parts

    avconv version 0.8.13-6:0.8.13-1, Copyright (c) 2000-2014 the Libav developers
      built on Jun 28 2014 17:50:37 with gcc 4.7.2
    Codecs:
     D..... = Decoding supported
     .E.... = Encoding supported
     ..V... = Video codec
     ..A... = Audio codec
     ..S... = Subtitle codec
     ...S.. = Supports draw_horiz_band
     ....D. = Supports direct rendering method 1
     .....T = Supports weird frame truncation
     ------
     DEA D  libspeex        libspeex Speex
     DEA D  nellymoser      Nellymoser Asao

### Get medadata of audio file

    mediainfo -f <file>


Javascript Console Cheat Sheet
------------------------------

### Listen into a prestream

As any user you can currently hack the prestream by looking up the
publisher's user id and subscribe the prestream manually. E.g.

    Blackbox.subscribe('t1054-u701956')

Note: As soon as the stream goes live, your client will subscribe a
2nd time and you will here an echo.


Rails Console Cheat Sheet
-------------------------

### Feature three randomly selected talks since yesterday

    Talk.order('RANDOM()').limit(3).each do |t|
      t.update_attribute :featured_from, 1.day.ago
    end

### Reload browser session of all attendenees of talk 737

    PrivatePub.publish_to '/t737/public', event: 'Reload'

### Enqueue all archived talks for processing

    Talk.archived.order('play_count DESC').each do |talk|
      puts talk.id
      if talk.recording_override.blank?
        Delayed::Job.enqueue(Reprocess.new(talk.id), queue: 'prio')
      else
        Delayed::Job.enqueue(ProcessOverride.new(talk.id), queue: 'prio')
      end
    end

### Manually asses talks

    puts *Talk.where("uri like 'lt%'").order(:id).map { |t| '% 4s % 5s % 5s %s' % [t.id, t.storage.values.select { |f| f[:ext]=='.flv' }.inject(0) {|r,s| r + s[:seconds].to_i }, t.recording_override?, t.teaser ] }

### RE(P)L into remote brwoser session

Value of `exec` has to be native JavaScript and will be evaluated in
the scope of instance of Angular's `session` service.

At this point the P in REPL is still missing.

#### Log an error to the console

    PrivatePub.publish_to '/t981/u1', { exec: '$log.error("hello")' }

#### Force a reload of the page

    PrivatePub.publish_to '/t981/u1', { exec: 'window.location.reload()' }

### Delete all guest users

    User.where(guest: true).destroy_all
