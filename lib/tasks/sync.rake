require 'action_view/helpers'

# http://dba.stackexchange.com/questions/25138/index-max-row-size-error

namespace :sync do

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
      venue.description ||= 'tbd.' # FIXME
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
end
