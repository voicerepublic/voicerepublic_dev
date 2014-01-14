Welcome to Kluuu
================

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


Start the whole stack
---------------------

Rails, Faye (PrivatePub) & Sphinx.

    foreman start
    

Run Specs
---------

To run specs Faye and a Sphinx daemon have to run.


TODO
----

 * fix authentication/authorization participation
 * rm app/models/klu_image.rb
 * landing_page/index en/de -> localize
 * clean up rake tasks in lib/tasks
 * write a cleanup db migration
 * cleanup assets
 * use request log analyzer
 * log which views/partials are actually used
 

FIXES (maybe outdated)
----------------------

 * Venue.update_all('user_id = 1', :user_id => nil)
 * Venue.all.each { |v| v.events.create(:start_time => 1.day.from_now, :duration => 90) if v.events.empty? }

Documentation
-------------

For general platform and development documentation please refer to the
[GitHub wiki pages](https://github.com/munen/kluuu/wiki).

### Build diagrams

    railroady -M | dot -Tsvg > doc/models_complete.svg
    railroady -b -M | dot -Tsvg > doc/models_brief.sv
    railroady -C | dot -Tsvg > doc/controllers_complete.svg
    railroady -b -C | dot -Tsvg > doc/controllers_brief.svg


## Platforms

### Production

 * Site: [http://kluuu.com](http://kluuu.com)

### Staging

* Site: [kluuu-staging.panter.ch](kluuu-staging.panter.ch)

## Build status

* Integration: [![Build Status](https://circleci.com/gh/munen/KluuU/tree/integration.png?circle-token=xxx
)](https://circleci.com/gh/munen/KluuU/tree/integration)
* Master: [![Build Status](https://circleci.com/gh/munen/KluuU/tree/master.png?circle-token=xxx
)](https://circleci.com/gh/munen/KluuU/tree/master)

## Code Quality

* Develop: [![Code Climate](https://codeclimate.com/repos/52508f2589af7e49eb005def/badges/41b20408f4ce36c7daed/gpa.png)](https://codeclimate.com/repos/52508f2589af7e49eb005def/feed)
* Master: [![Code Climate](https://codeclimate.com/repos/52508e7013d6371cde004e5f/badges/464d25e7b07281374bab/gpa.png)](https://codeclimate.com/repos/52508e7013d6371cde004e5f/feed)
