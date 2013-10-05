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
* [Code climate](https://codeclimate.com/repos/xxx/feed) for automated code reviews.

### Monitoring

* [NewRelic](https://rpm.newrelic.com/accounts/xxx/servers) for monitoring the application and collecting errors on the backend.
* [Google Analytics](http://www.google.com/analytics/) for web analytics.

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

* Integration: [![Code Climate](https://codeclimate.com/repos/xxx/badges/yyy/gpa.png)](https://codeclimate.com/repos/51875a30c7f3a37a7f00f592/feed)
* Master: [![Code Climate](https://codeclimate.com/repos/xxx/badges/yyy/gpa.png)](https://codeclimate.com/repos/5162f8a6f3ea0001d700664a/feed)
