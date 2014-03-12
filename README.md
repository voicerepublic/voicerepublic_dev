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


Audio cheat sheet
-----------------

### get duration

    soxi -D file.wav
    
### convert wav to flv

    avconv -y -i file.wav -acodec libspeex -ar 16k -ac 1 file.flv


