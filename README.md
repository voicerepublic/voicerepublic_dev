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


Branches and Hosts
------------------

develop

master     -> staging
production -> live


TODO
----

* fix authentication/authorization participation

* rm app/models/rating.rb
* rm app/models/klu_image.rb
* Venue.update_all('user_id = 1', :user_id => nil)
* landing_page/index en/de -> localize
* Venue.all.each { |v| v.events.create(:start_time => 1.day.from_now, :duration => 90) if v.events.empty? }
