namespace :data do
  namespace :migrate do

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

    # TODO as soon as this task is obsolete
    # rewrite scopes upcoming and archived to
    # use the state attribute
    # also add a db index on state
    task talk_states: :environment do
      puts 'postlive:'
      Talk.archived.where(state: nil).each do |talk|
        print " #{talk.id}"
        talk.update_current_state('postlive', true)
      end
      puts
      puts 'prelive:'
      Talk.upcoming.where(state: nil).each do |talk|
        print " #{talk.id}"
        talk.update_current_state('prelive', true)
      end
      puts
      puts 'live:'
      Talk.where(state: nil).each do |talk|
        print " #{talk.id}"
        talk.update_current_state('live', true)
      end
    end

  end
end
