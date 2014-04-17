require 'action_view/helpers'

namespace :sync do

  task :rp14 do

    rp14_user = User.first 
    rp14_tags = 're:publica'
    errors = []

    datetime_regex = /(\d\d)\.(\d\d)\.(\d\d\d\d) - (\d\d:\d\d)/
    
    url = 'https://re-publica.de/event/1/sessions/json'
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    data = JSON.load(open(url).read)
    items = data['items'].map { |i| OpenStruct.new(i) }

    items.each do |item|
      venue_uri = "rp://2014/room/#{item.room.tr(' ', '-')}"
      venue = Venue.find_or_initialize_by(uri: venue_uri)
      venue.title = "#{item.event_title} - #{item.room}"
      venue.teaser = item.event_description
      venue.description = 'tbd.' # FIXME
      venue.tag_list = rp14_tags
      venue.user = rp14_user
      unless venue.valid?
        puts *venue.errors.to_a
        exit
      end
      puts venue.attributes.to_yaml
      venue.save!
      
      talk_uri = "rp://2014/session/#{item.nid}"
      talk = Talk.find_or_initialize_by(uri: talk_uri)
      talk.venue = venue
      talk.title = item.title
      talk.teaser = item.description_short.strip.truncate(255)
      talk.description = ([ item.speaker_names * ', ',
                            item.category,
                            item.description.strip ] * '<br><br>' ).truncate(8191)
      talk.tag_list = rp14_tags
      _, d, m, y, t = item.datetime.match(datetime_regex).to_a
      raise "Unknown datetime format: #{item.datetime}" unless _
      talk.starts_at_date = [y, m, d] * '-'
      talk.starts_at_time = t
      talk.duration = item.duration.match(/\d+/).to_a.first
      unless talk.valid?
        puts talk.errors.to_a
        exit
      end
      puts talk.attributes.to_yaml
      talk.save!
      puts "updated: #{item.datetime} #{item.title} (#{item.speaker_names * ', '})"
    end
    
  end

end
