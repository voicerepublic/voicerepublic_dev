namespace :data do
  namespace :migrate do

    task recordings_without_file_suffix: :environment do
      Talk.all.each do |talk|
        next unless talk.recording
        begin
          talk.update_attribute :recording, talk.recording.match(/(.*).m4a/).captures.first
          puts "Updated recording for talk #{talk.id}: #{talk.recording}"
        rescue Exception => e
          puts "Could not update recording for talk #{talk.id}: #{talk.recording}"
          puts "Reason: #{e.message}"
        end
      end
    end

    task events_to_talks: :environment do
      Event.all.each do |event|
        puts "Create talk for event #{event.id}"
        talk = Talk.new({
          title:       event.title,
          starts_at:   event.start_time,
          duration:    event.duration,
          teaser:      event.title, # dup!
          description: event.title, # dup!
          record:      event.record
        })
        talk.venue_id   = event.venue_id
        talk.updated_at = event.updated_at
        talk.created_at = event.created_at
        talk.recording  = event.recording
        talk.ended_at   = event.end_at
        talk.save!
      end
    end
  end
end
