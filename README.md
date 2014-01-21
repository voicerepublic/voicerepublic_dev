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


Start the whole stack
---------------------

Rails, Faye (PrivatePub) & Sphinx.

    foreman start
    

Run Specs
---------

To run specs Faye and a Sphinx daemon have to run.


TODO
----
 
 * "noreply@kluuu.com" is a bad idea.
 * get rid of config/environments/staging.rb staging is not an environment
   (to have a different log level on staging put this info into settings)
 * app/views/layouts/application loads stylesheets based on controller
   this undermines the asset pipeline, get rid of it
 * fix authentication/authorization participation
 * clean up rake tasks in lib/tasks
 * write a cleanup db migration
 * cleanup assets
 * use request log analyzer
 * log which views/partials are actually used
 * https://github.com/ryanb/cancan#4-lock-it-down 
 * cleanup routes
 * get rid of 'bookmarks' remeniscence
 * get rid of 'status_update' remeniscence
 * get rid of local specific views
 
    % find ./ -name \*.en.html.erb
    ./app/views/inline_help/_dashboard_finances_charged.en.html.erb
    ./app/views/inline_help/_dashboard_finances_checkout.en.html.erb
    ./app/views/inline_help/_dashboard_bookmarks_info.en.html.erb
    ./app/views/inline_help/_dashboard_contacts_customer_service.en.html.erb
    ./app/views/inline_help/_dashboard_matches_finances.en.html.erb
    ./app/views/inline_help/_dashboard_messages.en.html.erb
    ./app/views/inline_help/_dashboard_news_info.en.html.erb
    ./app/views/inline_help/_dashboard_matches_first_kluuu.en.html.erb
    ./app/views/inline_help/_dashboard_finances_info.en.html.erb
    ./app/views/inline_help/_dashboard_matches_matches.en.html.erb
    ./app/views/inline_help/_dashboard_contacts_interesting_people.en.html.erb
    ./app/views/txt/agb.en.html.erb
    ./app/views/txt/tou.en.html.erb
    ./app/views/venues/_venue_video.en.html.erb
    % find ./ -name \*.en.html.haml
    ./app/views/landing_page/index.en.html.haml
    ./app/views/venues/txt/_venue_desc.en.html.haml
 

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


Code Quality
------------

* Develop: [![Code Climate](https://codeclimate.com/repos/52508f2589af7e49eb005def/badges/41b20408f4ce36c7daed/gpa.png)](https://codeclimate.com/repos/52508f2589af7e49eb005def/feed)
circleci.com/gh/munen/voicerepublic_devcodeclimate.com/repos/52508e7013d6371cde004e5f/badges/464d25e7b07281374bab/gpa.8ebbe8b002c7556614695f94dd6bd0e92ec532de)](https://codeclimate.com/repos/52508e7013d6371cde004e5f/feed)
