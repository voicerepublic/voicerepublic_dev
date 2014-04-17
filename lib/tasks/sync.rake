require 'action_view/helpers'

# http://dba.stackexchange.com/questions/25138/index-max-row-size-error

namespace :sync do

  task :rp14 do

    # TODO: hardcode the user for re:publica
    rp14_user = User.first
    rp14_tags = 're:publica'
    warnings, errors = [], []
    report = Hash.new { |h, k| h[k] = 0 }

    datetime_regex = /(\d\d)\.(\d\d)\.(\d\d\d\d)/

    url = 'https://re-publica.de/event/1/sessions/json'
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
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
        room = item.room.strip
        if room.blank?
          warnings << '% 4s: Room missing, item skipped.' % nid
          next
        end
        _, d, m, y = item.datetime.match(datetime_regex).to_a
        unless _
          warnings << "% 4s: Unknown datetime format: #{item.datetime}" % nid
          next
        end

        # update venue
        venue_uri = "rp://2014/room/#{item.room.strip.tr(' ', '-')}"
        venue = Venue.find_or_initialize_by(uri: venue_uri)
        venue.title = "#{item.event_title.strip} - #{room}"
        venue.teaser = item.event_description.strip
        venue.description = 'tbd.' # FIXME
        venue.tag_list = rp14_tags
        venue.user = rp14_user
        metric = venue.persisted? ? :venues_updated : :venues_created
        report[metric] += 1 if venue.save!

        # update talk
        talk_uri = "rp://2014/session/#{nid}"
        talk = Talk.find_or_initialize_by(uri: talk_uri)
        next unless talk.prelive?
        talk.venue = venue
        talk.title = item.title.strip
        talk.teaser = item.description_short.strip.truncate(255)
        talk.description = ([ item.speaker_names.map(&:strip) * ', ',
                              item.category.strip,
                              item.description.strip ] * '<br><br>' ).truncate(8191)
        talk.tag_list = rp14_tags
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

  end

end
