Welcome to Kluuu
================

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

### Thinking sphinx

Install sphinx: http://pat.github.io/thinking-sphinx/installing_sphinx.html

    bundle exec rake thinking_sphinx:configure
    bundle exec rake thinking_sphinx:index
    bundle exec rake thinking_sphinx:start

### nginx/rtmp server (Debian 7 & optional)

Make sure `libpcre++-dev` is installed. Run `rake rtmp:build`. The
config file is located here `config/rtmp.conf`. See
`lib/tasks/rtmp.rake` for more details.



Start the whole stack
---------------------

Rails, Faye (PrivatePub) & Sphinx.

    foreman start


Run Specs
---------

To run specs Faye and a Sphinx daemon have to run.


Compile Flash
-------------

Install Flex

    http://www.adobe.com/devnet/flex/flex-sdk-download.html

Make `bin` available in your PATH.

Run

    mxmlc lib/flash/Blackbox.as

Noteworthy Rake Tasks
---------------------

    rake audio:merge[talk_id,strategy_name]
    rake audio:transcode[talk_id,strategy_name]
    rake audio:transcode_missing[strategy_name]


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


### Merging Streams

#### Legacy code (lib/tasks/recordings.rake)

Merge all available recordings by event.

    rake recordings:merge

#### Strategy oriented code

The first argument is the ID of the talk to merge, the second is the
merge strategy to use, which is optional. The path to work in is set
by `Settings.rtmp.recordings_path`

    rake stream:merge[1]
    rake stream:merge[1,highly_experimental]

(Depending on you shell you might need to escape the square brackets.)

Note: Starting the StreamMerger via rake is only for development and
experiments. The StreamMerger will usually run via Delayed::Job.


Platforms
---------

### Production

 * Site: [http://kluuu.com](http://kluuu.com)

### Staging

* Site: [kluuu-staging.panter.ch](kluuu-staging.panter.ch)

