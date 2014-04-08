Welcome to VoiceRepublic
========================

![One does not simply...](http://www.memecreator.org/static/images/memes/809494.jpg)

"Work is the curse of the drinking classes." -- Gentleman Rhymer

## Build status

* Integration: [![Build Status](https://circleci.com/gh/munen/voicerepublic_dev/tree/integration.png?circle-token=f4b46938bc8855216230b287208fcc76062cc0a6
)](https://circleci.com/gh/munen/voicerepublic_dev/tree/integration)
* Master: [![Build Status](https://circleci.com/gh/munen/voicerepublic_dev/tree/master.png?circle-token=f4b46938bc8855216230b287208fcc76062cc0a6
)](https://circleci.com/gh/munen/voicerepublic_dev/tree/master)

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



Start the whole stack
---------------------

Rails, Faye (PrivatePub) & Sphinx.

    foreman start


Run Specs
---------

[Specs Wiki](https://github.com/munen/voicerepublic_dev/wiki/Development#wiki-specs)

Run

    mxmlc lib/flash/Blackbox.as


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
 * cleanup images !
 * use request log analyzer
 * log which views/partials are actually used
 * https://github.com/ryanb/cancan#4-lock-it-down
 * cleanup routes
 * get rid of 'bookmarks' remeniscence
 * get rid of 'status_update' remeniscence
 * rename app from Kluuu2 to VoiceRepublic
 * get rid of locale specific views

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

    rake audio:strategies

FIXES (maybe outdated)
----------------------

 * Venue.update_all('user_id = 1', :user_id => nil)
 * Venue.all.each { |v| v.events.create(:start_time => 1.day.from_now, :duration => 90) if v.events.empty? }


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

* Site: [http://voicerepublic.com](http://voicerepublic.com)

### Staging

* Site: [staging.voicerepublic.com](staging.voicerepublic.com)


Conference Features
-------------------

If the venue is a conference you might want to open the back office
app and put the following in options of the venue:

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
least once if you want to have multiple files. These will show up on
the console which runs `vrwatch`.)

Click `End Talk` to end the talk. On the rails console kick off post
processing (in User Acceptance Test mode) with:

    t.reload.send(:postprocess!, true)

Views will change slightly. A journal file shows up in `vrwatch`. When
running with parameter `true` a `debugger` statement will hold before
each Audio::Strategy to inspect the precondition and outcome in
`vrwatch`. Type `c` and `Enter` to continue to the next strategy. It
will output the shell-out-commands prefixed with `CmdRunner>`, any
errors and in red the next strategy to run. (At this point you can
run the shell-out-commands under `local/recordings` to play with them
and tweak stuff.)

After the last strategy post processing will move the files from
`recordings` to `archive` resp. `archive_raw`. It'll also create
symlinks to access these files via `public/system/audio`.

At that point the history of you rails console will be dead -- no clue
why. But you can simply quit the console and restart it to get it back.

Restart `vrwatch` to remove the artifacts and start over.

### Known Issues

* listener doesn't get out of state Registering, thus won't subscribe to the streams


Audio cheat sheet
-----------------

### get duration

    soxi -D file.wav

### convert wav to flv

    avconv -y -i file.wav -acodec libspeex -ar 16k -ac 1 file.flv


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
