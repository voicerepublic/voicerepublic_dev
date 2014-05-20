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

VR is being developed on Ruby 1.9.3. See (.ruby-version)[.ruby-version].

The use of (rbenv)[/sstephenson/rbenv] instead of RVM is highly recommended.

### Install rbenv on zsh

    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(rbenv init -)"' >> ~/.zshrc
    . ~/.zshrc
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    rbenv install `cat .ruby-version`

### Debian Packages

* postgresql-contrib-9.1
* libpcre++-dev
* libav-tools
* sox
* vorbis-tools


Setup
-----

    bundle
    rake db:setup
    rake db:migrate
    rake rtmp:build
    rake setup

### New Search

Make sure `postgresql-contrib-9.1` is installed.

    zeus rake pg_search:multisearch:rebuild\[Talk\]
    zeus rake pg_search:multisearch:rebuild\[Venue\]
    zeus rake pg_search:multisearch:rebuild\[User\]

### nginx/rtmp server (Debian 7 & optional)

Make sure `libpcre++-dev` is installed. Run `rake rtmp:build`. The
config file is located here `config/rtmp.conf.erb`. See
`lib/tasks/rtmp.rake` for more details.


Run Specs
---------

Run Rspec with Zeus

    zeus start
    zeus rspec spec

Install phantomjs (globaly)

    sudo npm install -g phantomjs

### Run Jasmine specs for Angular with Karma

    sudo npm install -g karma
    sudo npm install -g karma-ng-scenario
    karma start spec/javascripts/livepage.conf.js.coffee


Compile Flash
-------------

Install Flex

    http://www.adobe.com/devnet/flex/flex-sdk-download.html

Unpack and make `bin` available in your PATH.

Run

    zeus rake build:flash


Runnning Audio Strategies with Rake
-----------------------------------

List all available strategies

    rake audio:strategies

The generic strategy runner takes arguments

 * strategy name
 * path to audio files
 * name (talk_id, X in the flv files tX-u...)
    
    rake audio:run[strategy_name,path/to/files,name]

The output lists the resulting files.

(Depending on your shell, e.g. for zsh, you might have to escape the
square brackets with backslashes.)


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

    cap staging deploy

Deploy a specific branch to staging, e.g.

    REVISION=feature/65463494/subscribe_podcast cap staging deploy


Conference Features
-------------------

If the venue is a conference you might want to open the back office
app and put the following in options of the venue:

    ---
    no_auto_postprocessing: true
    no_email: true
    no_auto_end_talk: true
    suppress_chat: true


Console Cheat Sheet
-------------------

### Feature three randomly selected talks since yesterday

    Talk.order('RANDOM()').limit(3).each do |t|
      t.update_attribute :featured_from, 1.day.ago
    end

### Reload browser session of all attendenees of talk 737

    PrivatePub.publish_to '/t737/public', event: 'Reload'


Manual acceptance tests Cheat Sheet
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


Disk Space Requirements
-----------------------

    ratios = Talk.archived.map { |t| t.disk_usage / t.duration.to_f }
    mean = ratios.inject { |r, s| r + s } / qs.size.to_f
    mean / 1024.0

Backup
------

On VRBackup (Synology DiskStation)

    rsync -avz --progress app@voicerepublic.com:app backup


Audio cheat sheet
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


Transition to S3
----------------

The transition to s3 is a little more complicated than a regular
deploy. Changes at several locations have to be in sync, these
locations are:

 * code base
 * database
 * filesystem
 * s3

Through temporary redundancies we'll have a working app at all times,
apart from audio processing, which we'll shut down during the upgrade
to make sure no new, untracked files are created while upgrading.

### Step 1: Shut down Audio DJs

Disable monitoring for audio djs in monit and stop.

### Step 2: Run Rake Task 1/2

Since this has to happen before the deploy, I suggest to scp the rake
file over to the server.

    scp lib/tasks/cleanup.rake vrs:app/current/lib/tasks

Will take care of

 * db: update talks#uri
 * fs: move processing log files to new location
 * fs: upload all audio files to s3 (this might take a while)

Run

    rake cleanup:move_to_s3_step1

### Step 3: Deploy Migrations & Code Changes

As you would normally deploy.

Test the system thourougly before proceeding! 

### Step 4: Run Rake Task 2/2

Will take care of

 * fs: remove ephemeral symlinks
 * fs: delete archive and archive_raw

This is a good time to run a local backup of all audio files (although
this might take a while)

    scp -r vrs:app/shared/archive .
    scp -r vrs:app/shared/archive_raw .

Run

    rake cleanup:move_to_s3_step2

### Step 5: Start Audio DJs

Reenable monitoring for audio djs in monit and start.
