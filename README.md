Welcome to Kluuu
================

![One does not simply...](http://www.memecreator.org/static/images/memes/809494.jpg)

"Work is the curse of the drinking classes." -- Gentleman Rhymer

## Build status

* Integration: [![Build Status](https://circleci.com/gh/munen/voicerepublic_dev/tree/develop.png?circle-token=8ebbe8b002c7556614695f94dd6bd0e92ec532de
)](https://circleci.com/gh/munen/KluuU/tree/integration)
* Master: [![Build Status](https://circleci.com/gh/munen/voicerepublic_dev/tree/master.png?circle-token=8ebbe8b002c7556614695f94dd6bd0e92ec532de
)](https://circleci.com/gh/munen/KluuU/tree/master)

## Code Quality

* Develop: [![Code Climate](https://codeclimate.com/repos/52d695526956802e2600897b/badges/d72650afa4aea3392af9/gpa.png)](https://codeclimate.com/repos/52d695526956802e2600897b/feed)


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



Start the whole stack
---------------------

Rails, Faye (PrivatePub) & Sphinx.

    foreman start


Run Specs
---------

Install phantomjs (globaly)

    sudo npm install -g phantomjs

To run specs Faye and a Sphinx daemon have to run.

### Run Jasmine specs for Angular with Karma

    sudo npm install -g karma
    sudo npm install -g karma-ng-scenario
    karma start spec/javascripts/livepage.conf.js.coffee


Compile Flash
-------------

Install Flex

    http://www.adobe.com/devnet/flex/flex-sdk-download.html

Make `bin` available in your PATH.

Run

    mxmlc lib/flash/Blackbox.as


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

(Depending on your shell you might have to escape the square brackets
with backslashes.)


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


Platforms
---------

### Production

 * Site: [http://kluuu.com](http://kluuu.com)

### Staging

* Site: [kluuu-staging.panter.ch](kluuu-staging.panter.ch)



Console Cheat Sheet
-------------------

### Feature three randomly selected talks since yesterday

    Talk.order('RANDOM()').limit(3).each do |t|
      t.update_attribute :featured_from, 1.day.ago
    end


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

    % bin/vrwatch

On a rails console, pick the talk you want to work with (e.g. id 42)
and reset it to start soon (e.g. `20.seconds.from_now`). (Don't use
`update_attribute`, since it will not trigger the callbacks.)

    t = Talk.find(42); nil
    t.reload; t.starts_at = 20.seconds.from_now; t.state = 'prelive'; t.save

Then reload the browsers. It will record a couple of seconds
pretalk. You should see the file size in `vrwatch` go up. After the
time to start is up it will switch to live mode automatically. With
your second Browser you should hear yourself now. (Reload the host at
least once to have multiple streams. these will show up on the console
which runs `vrwatch`.)

Click `End Talk` to end the talk. On the rails console kick off post
processing with:

    t.reload.send(:postprocess!)

Views will change slightly. A journal file shows up in `vrwatch`. When
running in console a `debugger` statement will hold before each
Audio::Strategy to inspect the precondition and outcome in
`vrwatch`. Type `c` and `Enter` to continue to the next strategy. It
will output the shell-out-commands prefixed with `CmdRunner>`, any
errors and in red the next strategy to run.

After the last strategy post processing will move the files from
`recordings` to `archive` resp. `archive_raw`. It'll also create
symlinks to access these files via `public/system/audio`.

At that point the history of you rails console will be dead -- no clue
why. But you can simply quit the console and restart it to get it back.

Restart `vrwatch` to remove the artifacts and start over.


Audio cheat sheet
-----------------

### get duration

    soxi -D file.wav
    
### convert wav to flv

    avconv -y -i file.wav -acodec libspeex -ar 16k -ac 1 file.flv


