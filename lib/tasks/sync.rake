require 'action_view/helpers'

# http://dba.stackexchange.com/questions/25138/index-max-row-size-error

namespace :sync do

  # TODO: BTR talks can be only 8kbit/s. The current avconv implementation
  # sometimes will not transcode these files.
  # https://www.pivotaltracker.com/story/show/79026058
  task :btr_user, [:user_id, :rss_feed] => :environment  do |t, args|
    raise 'Usage: rake "sync:btr_user[8188, http://www.blogtalkradio.com/back2us.rss]"' unless (args[:user_id] and args[:rss_feed])

    user = User.find args[:user_id]
    raise "Cannot find btr_user with VR ID: #{args[:user_id]}" unless user

    text_limit = 8191 # general limit for text fields
    text_limit = 2300 # limit for full text search
    string_limit = 140

    warnings, errors = [], []
    report = Hash.new { |h, k| h[k] = 0 }

    print 'Fetching data...'
    xml = open(args[:rss_feed]).read
    puts 'done.'
    doc = Nokogiri::Slop(xml)

    doc.rss.channel.item.each do |event|

      begin
        btr_id = event.guid.text.hash

        # update venue
        title = event.title.text.strip.truncate(string_limit)
        venue_uri = "btr://#{user.slug}/#{title}"
        venue = Venue.find_or_initialize_by(uri: venue_uri)
        venue.title = title
        venue.teaser = event.send('itunes:subtitle').text.strip.truncate(string_limit)
        venue.description = event.send('itunes:summary').text.strip.truncate(text_limit)
        # Downcasing is necessary, because BTR does not differenciate between
        # 'foo' and 'Foo'. ActsAsTaggableOn does, however.
        venue.tag_list = event.send("itunes:keywords").text.split(",").map(&:downcase).uniq
        venue.tag_list = "default" if venue.tag_list.empty?
        venue.user = user
        metric = venue.persisted? ? :venues_updated : :venues_created
        report[metric] += 1 if venue.save!

        # update talk
        talk_uri = "btr-#{btr_id}"
        talk = Talk.find_or_initialize_by(uri: talk_uri)
        talk.venue = venue
        talk.title = venue.title
        talk.teaser = venue.teaser
        talk.description = venue.description
        talk.tag_list = venue.tag_list
        talk.state = 'postlive'

        talk.starts_at_date = Date.parse(event.pubDate).strftime("%Y-%m-%d")
        talk.starts_at_time = Date.parse(event.pubDate).strftime("%H:%M")
        duration = event.send("itunes:duration").text.split(":").map(&:to_i)

        talk.duration = (duration[0] * 60 + duration[1]).to_s
        metric = talk.persisted? ? :talks_updated : :talks_created
        report[metric] += 1 if talk.save!

        begin
          mp3_url = event.send('media:group').try(:send, 'media:content').first.attribute('url').text
          if mp3_url
            talk.update_attribute :recording_override, mp3_url
            talk.delay(queue: 'audio').send(:process_override!)
          end
        rescue NoMethodError
          # event might not have an audio file attached
        end

        print '.'

      rescue Exception => e
        errors << '% 4s: %s' % [btr_id, e.message.tr("\n", ';')]
      end
    end

    # START Cleanup:
    #  * Talks of Series with only one talk will be aggregated into a Series
    #    "misc"
    #  NOTE: Yes, it's ugly to first create and destroy stuff.
    venues = user.venues.collect { |v| v if v.talks.length == 1 }.compact

    puts
    puts "Found #{venues.length} venues with only one talk!"
    return unless venues.length

    venue_misc = Venue.find_or_initialize_by title: "Misc",
      description: "There can be only one",
      teaser: "Misc",
      user: user
    venue_misc.tag_list = "general"
    venue_misc.save!

    venues.each do |v|
      talk = v.talks.first
      talk.venue = venue_misc
      talk.save!
      v.reload.destroy!
    end
    puts "Moved talks into venue: #{venue_misc.id}"
    # END Cleanup

    puts
    puts
    puts "REPORT"
    puts
    puts "  Venues updated: #{report[:venues_updated]}"
    puts "  Venues created: #{report[:venues_created]}"
    puts "  Talks  updated: #{report[:talks_updated]}"
    puts "  Talks  created: #{report[:talks_created]}"
    puts
    puts "WARNINGS (#{warnings.size})"
    puts
    puts *warnings
    puts
    puts "ERRORS (#{errors.size})"
    puts
    puts *errors
    puts

    #talks =  Talk.order('starts_at ASC').where("uri LIKE 'btr://#{user.slug}/%'")

    #puts "LINEUP (#{talks.count})"
    #puts
    #talks.each do |t|
    #  puts [ t.uri.sub('btr://#{user.slug}/', ''),
    #         "https://voicerepublic.com/talk/#{t.id}",
    #         t.venue.title,
    #         t.title.inspect,
    #         t.starts_at ] * ','
    #end
    #puts

  end

  task lt14: :environment do
    raise 'No linuxtag_user_id' unless Settings.linuxtag_user_id
    lt14_user = User.find Settings.linuxtag_user_id

    lt14_opts = {
      no_auto_postprocessing: true,
      no_auto_end_talk: true,
      no_email: true,
      suppress_chat: true,
      process_chain:
        'precursor normalize kluuu_merge trim m4a mp3 ogg move_clean m4a mp3 ogg',
      override_chain:
        'm4a mp3 ogg move_clean m4a mp3 ogg'
    }

    text_limit = 8191 # general limit for text fields
    text_limit = 2300 # limit for full text search
    string_limit = 140

    warnings, errors = [], []
    report = Hash.new { |h, k| h[k] = 0 }

    datetime_regex = /(\d\d)\.(\d\d)\.(\d\d\d\d)/
    duration_regex = /(\d\d):(\d\d):(\d\d)/

    url = Rails.root.join('doc/lt14.xml')
    print 'Fetching data...'
    xml = open(url).read
    puts 'done.'
    doc = Nokogiri::Slop(xml)

    doc.program.event.each do |event|

      begin
        _, d, m, y   = event['date'].match(datetime_regex).to_a
        _, h, min, s = event['duration'].match(duration_regex).to_a

      room = event['room']
      venue_uri = "lt://2014/room/#{room.tr(' ', '-')}"
      venue = Venue.find_or_initialize_by(uri: venue_uri)
      venue.title = room
      venue.teaser ||= 'brought to you by VoiceRepublic'
      venue.description ||= 'tbd.'
      venue.tag_list = 'linuxtag' # rp14_tags[category]
      venue.user = lt14_user
      venue.options = lt14_opts
      metric = venue.persisted? ? :venues_updated : :venues_created
      report[metric] += 1 if venue.save!

      ltid = event['id']

      # update talk
      talk_uri = "lt://2014/session/#{ltid}"
      talk = Talk.find_or_initialize_by(uri: talk_uri)
      # next unless talk.prelive?
      talk.venue = venue
      talk.title = event.talk.title.text.strip.truncate(string_limit)
      talk.teaser = 'tbd.' # FIXME
      talk.description = 'tbd.' # FIXME
      talk.tag_list = 'linuxtag' # FIXME rp14_tags[category]
      talk.starts_at_date = [y, m, d] * '-'
      talk.starts_at_time = event['starttime']
      talk.duration = (h * 60 + min).to_s
      metric = talk.persisted? ? :talks_updated : :talks_created
      report[metric] += 1 if talk.save!
      #if talk.ends_at.strftime('%H:%M') != item.end
      #    warnings << '% 4s: Bogus times: %s %s' % [nid, item.datetime, item.duration]
      #  end
      print '.'

      rescue Exception => e
        errors << '% 4s: %s' % [ltid, e.message.tr("\n", ';')]
      end
    end

    puts
    puts
    puts "REPORT"
    puts
    puts "  Venues updated: #{report[:venues_updated]}"
    puts "  Venues created: #{report[:venues_created]}"
    puts "  Talks  updated: #{report[:talks_updated]}"
    puts "  Talks  created: #{report[:talks_created]}"
    puts
    puts "WARNINGS (#{warnings.size})"
    puts
    puts *warnings
    puts
    puts "ERRORS (#{errors.size})"
    puts
    puts *errors
    puts

    talks =  Talk.order('starts_at ASC').where("uri LIKE 'lt://2014/%'")

    puts "LINEUP (#{talks.count})"
    puts
    talks.each do |t|
      puts [ t.uri.sub('lt://2014/session/', ''),
             "https://voicerepublic.com/talk/#{t.id}",
             t.venue.title,
             t.title.inspect,
             t.starts_at ] * ','
    end
    puts

  end



  task rp14: :environment do

    raise 'No republica_user_id' unless Settings.republica_user_id
    rp14_user = User.find Settings.republica_user_id
    rp14_tags = {
      'Culture'               => 'republica, Culture, Kultur',
      'Politics & Society'    => 'republica, Politics, Politik, Society, Gesellschaft',
      'Media'                 => 'republica, Media, Medien',
      'Research & Education'  => 'republica, Research, Forschung, Education, Bildung',
      'Business & Innovation' => 'republica, Business, Innovation, Wirtschaft',
      'Science & Technology'  => 'republica, Science, Wissenschaft, Technology, Technologie',
      're:publica'            => 'republica, Conference, Konferenz'
    }

    rp14_opts = {
      no_auto_postprocessing: true,
      no_auto_end_talk: true,
      no_email: true,
      suppress_chat: true,
      process_chain:
        'precursor normalize kluuu_merge trim m4a mp3 ogg move_clean rp14 m4a mp3 ogg',
      override_chain:
        'm4a mp3 ogg move_clean rp14 m4a mp3 ogg'
    }

    text_limit = 8191 # general limit for text fields
    text_limit = 2300 # limit for full text search
    string_limit = 140

    warnings, errors = [], []
    report = Hash.new { |h, k| h[k] = 0 }

    datetime_regex = /(\d\d)\.(\d\d)\.(\d\d\d\d)/

    url = 'http://re-publica.de/event/1/sessions/json'
    print 'Fetching data...'
    json = open(url).read
    puts 'done.'
    data = JSON.load(json)
    items = data['items'].map { |i| OpenStruct.new(i) }
    puts "Found #{items.size} items."

    items.each do |item|
      begin
        # sanity checks
        nid = item.nid
        raise 'No nid' if nid.blank?
        category = item.category.strip
        if category.blank?
          warnings << '% 4s: Category missing, item skipped.' % nid
          next
        end
        _, d, m, y = item.datetime.match(datetime_regex).to_a
        unless _
          warnings << "% 4s: Unknown datetime format: #{item.datetime}" % nid
          next
        end

        # update venue
        venue_uri = "rp://2014/category/#{category.tr(' ', '-')}"
        venue = Venue.find_or_initialize_by(uri: venue_uri)
        venue.title = category
        venue.teaser ||= item.event_description.strip.truncate(string_limit)
        venue.description ||= 'tbd.' # FIXME
        venue.tag_list = rp14_tags[category]
        venue.user = rp14_user
        venue.options = rp14_opts
        metric = venue.persisted? ? :venues_updated : :venues_created
        report[metric] += 1 if venue.save!

        # update talk
        talk_uri = "rp://2014/session/#{nid}"
        talk = Talk.find_or_initialize_by(uri: talk_uri)
        next unless talk.prelive?
        talk.venue = venue
        talk.title = item.title.strip.truncate(string_limit)
        talk.teaser = item.description_short.strip.truncate(string_limit)
        talk.description = ([ item.speaker_names.map(&:strip) * ', ',
                              'Room: ' + item.room.strip,
                              item.description.strip ] * '<br><br>' ).
                           truncate(text_limit)
        talk.tag_list = rp14_tags[category]
        talk.starts_at_date = [y, m, d] * '-'
        talk.starts_at_time = item.start
        talk.duration = item.duration.match(/\d+/).to_a.first
        metric = talk.persisted? ? :talks_updated : :talks_created
        report[metric] += 1 if talk.save!
        if talk.ends_at.strftime('%H:%M') != item.end
          warnings << '% 4s: Bogus times: %s %s' % [nid, item.datetime, item.duration]
        end
        print '.'
      rescue Exception => e
        errors << '% 4s: %s' % [nid, e.message.tr("\n", ';')]
      end
    end

    puts
    puts
    puts "REPORT"
    puts
    puts "  Venues updated: #{report[:venues_updated]}"
    puts "  Venues created: #{report[:venues_created]}"
    puts "  Talks  updated: #{report[:talks_updated]}"
    puts "  Talks  created: #{report[:talks_created]}"
    puts
    puts "WARNINGS (#{warnings.size})"
    puts
    puts *warnings
    puts
    puts "ERRORS (#{errors.size})"
    puts
    puts *errors
    puts

    talks =  Talk.order('starts_at ASC').where("uri LIKE 'rp://2014/%'")

    puts "LINEUP (#{talks.count})"
    puts
    talks.each do |t|
      puts [ t.uri, "https://voicerepublic.com/talk/#{t.id}",
             t.description[/Room: (.*)<br><br>/, 1], t.title.inspect, t.starts_at ] * ','
    end
    puts

  end

  task rp15: :environment do
    Sync::Rp15.new.sync
  end

end
