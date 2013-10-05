Welcome to Kluuu
================

Setup
-----

### Thinking sphinx

* Install sphinx: http://pat.github.io/thinking-sphinx/installing_sphinx.html
* bundle exec rake thinking_sphinx:configure
* bundle exec rake thinking_sphinx:index
* bundle exec rake thinking_sphinx:start

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

* rm app/models/rating.rb
* rm app/models/klu_image.rb
* Venue.update_all('user_id = 1', :user_id => nil)
* landing_page/index en/de -> localize
* Venue.all.each { |v| v.events.create(:start_time => 1.day.from_now, :duration => 90) if v.events.empty? }




## Documentation

For general platform and development documentation please refer to the
[GitHub wiki pages](https://github.com/munen/kluuu/wiki).

## Services

KluuU makes use of the following external services:

### Analysis

* [Pivotal Tracker](https://www.pivotaltracker.com/s/projects/927712) for managing the user stories.
 * kluuu@dispatched.ch / gFxmaJCue3AD9j

### Development

* [GitHub](https://github.com/munen/KluuU) for source control management and developer collaboration.
* [CircleCI](https://circleci.com/xxx) as continuous integration server.
* [Code climate](https://codeclimate.com/repos/52508e7013d6371cde004e5f/feed) for automated code reviews.
 * kluuu@dispatched.ch / g9jMmjckwzKb2o  

### Monitoring

* [NewRelic](https://rpm.newrelic.com/accounts/xxx/servers) for monitoring the application and collecting errors on the backend.
* [Google Analytics](http://www.google.com/analytics/) for web analytics.
* [Uptimerobot](http://uptimerobot.com/) 
 * accounts@dispatched.ch / JaG9UAbXezJ8zm

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
