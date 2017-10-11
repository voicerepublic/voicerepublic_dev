Welcome to VoiceRepublic
========================

#### Integration [![Circle CI](https://circleci.com/gh/munen/voicerepublic_dev.svg?style=svg&circle-token=f4b46938bc8855216230b287208fcc76062cc0a6)](https://circleci.com/gh/munen/voicerepublic_dev), Master [![Circle CI](https://circleci.com/gh/munen/voicerepublic_dev/tree/master.svg?style=svg&circle-token=f4b46938bc8855216230b287208fcc76062cc0a6)](https://circleci.com/gh/munen/voicerepublic_dev/tree/master)

![One does not simply...](http://www.memecreator.org/static/images/memes/809494.jpg)

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

### Use spring

To make you shell find the springified binstubs, put this in your
shell's config (e.g. `.zshrc` or `.bashrc`)

    export PATH=./bin:$PATH


Setup
-----

    bundle
    cp config/settings.local.yml.sample \
       config/settings.local.yml
    cp config/database.yml.example \
       config/database.yml             # use an appropriate db config

    # edit template files

    rake db:setup                      # this requires an internet connection, also
                                       # [also see note below]
    rake db:migrate                    # also requires an internet connection


    rake db:sync:live
    rake db:sync:live_images

Above the step `rake db:setup` probably fails, if the connecting user
in database.yml doesn't have 'superuser' rights when connecting to the
psql server. So you might want to replace that step by:

    $ sudo su
    # su - postgres
    $ psql
    postgres=# create database vr_development owner your_db_user;


### New Search

Make sure `postgresql-contrib-9.1` is installed.

    rake pg_search:multisearch:rebuild\[Talk\]
    rake pg_search:multisearch:rebuild\[Venue\]
    rake pg_search:multisearch:rebuild\[User\]

### Create Postgres Extensions

Sidenote: This is also automatically done by `rake db:create`.

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

* `rails s -b 0.0.0.0`
* `rackup -E production faye.ru -o 0.0.0.0`
* `lib/flux_capacitor.rb run`
* `rake jobs:work`
* `cd lib/vrng && rlwrap lein figwheel`
* `docker start rabbitmq`

### or optionally voicerepublic_dev with tmux

* `sudo apt-get install tmux`
* `bin/start_everything_in_tmux`

### voicerepublic_backoffice

* `rails s -p 3001`


Specs
-----

### Rails

Setup: Install phantomjs (globaly)

    sudo npm install -g phantomjs

Run all specs

    rspec spec

If you want to skip specs tagged as slow or to run in chrome, add this
to your `.rspec` file

    --tag ~@driver:chrome
    --tag ~@slow

To run specs tagged to run in chrome

    rspec --tag @driver:chrome

To run specs tagged as slow

    rspec --tag @slow

### Angular

Setup: Install karma & coffee-script

    sudo npm install -g karma
    sudo npm install -g karma-ng-scenario
    sudo npm install -g coffee-script

Run Jasmine specs for Angular with Karma

    karma start spec/javascripts/livepage.conf.js.coffee


Run Audio Strategies
--------------------

See [fidelity](https://github.com/munen/fidelity) for details.

### Example

Pull complete audio data for a given talk from s3

    s3cmd sync s3://vr-live-media/vr-1799 .

Sometimes it is a good idea to delete the journal

    rm vr-1799/1799.journal

Run fidelity on it

    fidelity run vr-1799/manifest-1799.yml

To update fidelity, run

    bundle update --source fidelity


Documentation
-------------

For general platform and development documentation please refer to the
[GitHub wiki pages](https://github.com/munen/voicerepublic_dev/wiki).


### Build diagrams

    railroady -M | dot -Tsvg > doc/models_complete.svg
    railroady -b -M | dot -Tsvg > doc/models_brief.svg
    railroady -C | dot -Tsvg > doc/controllers_complete.svg
    railroady -b -C | dot -Tsvg > doc/controllers_brief.svg

    mscgen -T svg -o doc/streaming.svg doc/streaming.msc
    mscgen -T png -o doc/streaming.png doc/streaming.msc

    dot -Tsvg doc/fsm_venue.dot > doc/fsm_venue.svg
    dot -Tpng doc/fsm_venue.dot > doc/fsm_venue.png

    dot -Tsvg doc/fsm_device.dot > doc/fsm_device.svg
    dot -Tpng doc/fsm_device.dot > doc/fsm_device.png


### Working with Settings/Config

Config entries are compiled from:

    config/settings.yml
    config/settings/#{environment}.yml
    config/environments/#{environment}.yml

    config/settings.local.yml
    config/settings/#{environment}.local.yml
    config/environments/#{environment}.local.yml

Settings defined in files that are lower in the list override settings
higher.

IMPORTANT! We break we this schema of reading config files when it
comes to microservices. The services (in `app/services`) rarely boot
the whole rails stack (this keeps the memory footprint low). As a side
effect they don't have access to the whole settings. **Only settings in
the `settings.local.yml` will be available to microservices.**


### A note on emails

These files...

    public/images/email_header.png
    public/images/email_header.svg
    public/images/icons/facebook.png
    public/images/icons/link.png
    public/images/icons/twitter.png

(except the svg) are linked to from...

    app/views/layouts/mailer.html.erb

It makes since to put these NOT in `app/assets/images`, otherwise the
MUAs will get 404s on emails that were sent from older releases.


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

    % rake rtmp:start

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

### Get medadata of audio file

    mediainfo -f <file>


Rails Console Cheat Sheet
-------------------------

### Set a penalty on a user

     User.find_by(slug: 'back2us-radio').set_penalty!(0.5)

### List popular with position, rank, penalty, id, and title

    Talk.popular.limit(15).each_with_index do |t, i|
      puts [i+1, t.popularity, t.penalty, t.id, t.title]*"\t"
    end; nil

### Debug Postprocessing

    id = 3322
    Talk.find(id).update_attribute(:state, 'postlive')
    Delayed::Job.enqueue(Postprocess.new(id: id), queue: 'audio')

### Feature three randomly selected talks since yesterday

    Talk.order('RANDOM()').limit(3).each do |t|
      t.update_attribute :featured_from, 1.day.ago
    end

### Reload browser session of all attendenees of talk 737

    PrivatePub.publish_to '/t737/public', event: 'Reload'

### Send Message as JavaScript Popup

    PrivatePub.publish_to '/t1857/u1462094', { exec: 'alert("Hallo, hab gerade reingehoert, ich erklaere dir gerne wie du die Soundqualitaet merklich verbessern kannst. Meld dich dazu mal ueber unser Feeback Tool unten rechts. Gruss phil")' }

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


Embed player to Facebook
------------------------

FB uses the OpenGraph Protocol to assess how to embed content to the FB
timeline. The protocol is described here:

    http://ogp.me

What metadata will actually be read and whether it is valid metadata concerning
FB can be checked out here:

    https://developers.facebook.com/tools/debug/og/object/

FB seems to be able to embed content that has the mime-type (or OpenGraph
protocol og:video:type) 'text/html'. However, during my research I have only
seen this in action for Youtube and Soundcloud. Interestingly enough,
Soundcloud supplies a flash player using OGP, but FB renders a HTML5 player. On
StackOverflow I have found comments from FB devs that FB actively works to
include other big players content - the rest of us has to do it ourselves.

Point being is that embedding our HTML5 player turned out to not be possible.
FB would stop at complaining in the Object Debugger about Unsafe Content being
injected and that a safe_url should be specified. From the documentation, this
message should indicate that a HTTPS URl should be used. This hasn't helped.
From not being able to find any other embedded HTML5 content that is not
Youtube or Soundcloud, I come to the conclusion that the Flash API is the only
valid option to currently embed rich content to a FB timeline. This is what is
currently implemented.

On iOS the player will not run directly, but a click on the 'play' button will
result in opening the actual VR page. This is the same workflow that Soundcloud
uses.

A screenshot walkthrough of sharing to FB is provided here:

    https://www.evernote.com/l/ABNyS_B91y9DSKdaiFLS2qcWtrNZaxlCdbQ

Note: embedding HTML5 to FB can be done in so called "Apps". These are hosted
in the 'app.facebook.com/name_of_app' namespace. There, it is easily possible to
show our embedded player. However, these apps are intended for different
purposes - for example games can be played. These would profit from a strong FB
integration (i.e. these games can create 'objects', count them, make relations
between other objects and people on FB and then post this information on a
timeline ['Alice has thrown 22 sheep on Bob']). Unfortunately, this is something
different than embedding foreign rich content onto a FB timeline, however.


Shell Cheat Sheet
-----------------

    ls -la ~/app/shared/log/ | grep -v .gz

    tail -f ~/app/shared/log/unicorn.stderr.log

    nano ~/.unicorn-config

    unicorn_wrapper restart


How To Update Icons
-------------------

* Go to https://icomoon.io/app/
* load the json file from `doc/vr-icons.zip`.
* Make changes
* "Generate Font"
* Download an updated zip & unpack
* `cp fonts/* app/assets/fonts`
* update `app/assets/stylesheets/grids_variables_mixins/style.css` with content of `style.css` (only the lower part, keep the top part!)
* done


How To Update Modernizr
-----------------------

https://modernizr.com/download

Unselect

* minify (on the left)

Select

* Touch Events

(Add anything else we need, and add it to this list.)

Click BUILD

Download to vendor/assets/modernizr.js


ClojureScript
-------------

    cd lib/vrng
    lein figwheel


Icecast Dev
-----------

    docker build -t branch14/icecast2 lib/icecast

    docker exec -it icecast bash


Helpful
-------

```
slug = ''

reload!; Venue.find(slug).reset!

reload!; Venue.find(slug).talks.prelive.first.make_it_start_soon! 91.minutes



reload!; Venue.find(124).reset!

reload!; Talk.find(4147).make_it_start_soon! 91.minutes; nil


Talk.suspended.order('id desc').limit(10).each(&:enqueue!)

Venue.not_offline.each(&:reset!)

puts *Venue.not_offline.pluck(:slug, :state).map { |a| a.join("\t")}


venue = Venue.find('venue-of-senior-hofmann')
talk = venue.talks.suspended.last
talk.title

talk = Talk.find('ontologische-relativitat')
talk.update_attribute :state, 'postlive'
talk.reload
talk.archive_from_dump!

```

Troubleshooting Audio Processing
--------------------------------

You need to have fidelity installed.

    mkdir -p /tmp/fid
    cd /tmp/fid

If processing goes wrong, download the bucket/prefix in question.

E.g.

    aws s3 sync s3://vr-live-media/vr-6123 .

Run fidelity

    fidelity run manifest.yml

And see.


Working with CLJS
-----------------

    lein upgrade
    lein deps


Creating new Pages
------------------

This is best described with an example:

To create a page available as `/pages/desktop-live-streaming` you just
need to create a symlink in `app/views/pages`

    ln -s __basic.html.haml app/views/pages/desktop-live-streaming.html.haml

Here we use the template `__basic.html.haml` which currently is the
only template. Instances of sections to fill this page will be created
after the new pages as been vistited at least once.


Repo Mapping (Github -> Gitlab)
-------------------------------

```
| git@github.com:munen/        | git@gitlab.com:voicerepublic/ |
|------------------------------+-------------------------------|
| fidelity.git                 | fidelity.git                  |
| pdf-viewer.git               | pdf-viewer.git                |
| voicerepublic_backoffice.git | backoffice.git                |
| voicerepublic_dev.git        | (still on github)             |
```

### Transition to Gitlab

```
REPO=fidelity.git

git remote rm origin
git remote add origin git@gitlab.com:voicerepublic/$REPO
git branch --set-upstream-to=origin/master master
git branch --set-upstream-to=origin/integration integration
git pull
git push

```
