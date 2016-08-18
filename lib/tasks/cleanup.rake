namespace :cleanup do
  desc 'Correctly set content-type for M4A files in S3'
  task :set_content_type => :environment do
    directory = Storage.directories.get(Settings.storage.media)

    directory.files.each do |f|
      content_type = case f.key.split(".").last.downcase
        when "m4a" then "audio/mp4"
        when "mp3" then "audio/mpeg"
        when "ogg" then "audio/ogg"
        else next
        end
      options = {
        'Content-Type' => content_type,
        'x-amz-metadata-directive' => 'REPLACE'
      }
      begin
        f.copy(f.directory.key, f.key, options)
        Rails.logger.info "Updated content-type on file: '#{f.key}'"
      rescue Exception => e
        Rails.logger.error "Could not update content-type on file: '#{f.key}'"
        Rails.logger.error "Error: '#{e.message}'"
      end
    end
  end

  desc 'Regenerate all flyers'
  task :regenerate_flyers => :environment do
    count = Talk.count
    Talk.find_each do |t|
      puts "Generate flyer for Talk #{t.id}/#{count}: #{t.title}"
      t.flyer.generate!
    end
  end

  # When a talk has been created, but the host never shows, the talk will never
  # proceed to further states. For the time being, this is corrected here.
  desc 'Set abandoned talks to state postlive'
  task fix_abandoned_talk_state: :environment do
    Talk.prelive.where("ends_at < ?", DateTime.now).each do |t|
      t.abandon!
    end
  end

  desc 'stops disused streaming servers'
  task stop_disused_streaming_servers: :environment do
    candidates = Venue.not_offline
    candidates -= Venue.not_offline.with_live_talks
    candidates -= Venue.not_offline.with_upcoming_talks
    candidates.each do |venue|
      puts "Send shutdown signal to venue #{venue.slug}"
      venue.shutdown!
    end
  end

  desc 'Remove listener that has not visited during the Live phase'
  task :remove_listener_non_live => :environment do
    puts "Starting to remove listeners during the non-Live phase of talks"
    # Find all talks that have listeners saved
    talk_ids = Talk.find_by_sql "select id from talks where listeners NOT LIKE '%--- {}%';"
    puts "Going over '#{talk_ids.size}' talks, this might take a While. "

    # Counts whether a listener came in during the live phase
    res = { yes: 0, no: 0 }
    talk_ids.each_with_index do |t_id, index|
      talk = Talk.find t_id
      listeners = {}
      # Both timestamps can be nil, but `to_i` will convert them to 0
      started_at = talk.started_at.to_i
      ended_at   = talk.ended_at.to_i
      changed = false
      talk.listeners.each do |k, v|
        if (started_at..ended_at).include?(v)
          res[:yes]=res[:yes].next
          # Using a tmp variable here to make sure that no Rails hooks
          # are being triggered. There's lots of removals to be
          # done. Saving, validation and similar should only happen
          # once!
          listeners[k] = v
        else
          changed = true
          res[:no]=res[:no].next
        end

      end
      talk.update_column(:listeners, listeners) if changed

      if index > 0 && index % 5 == 0
        puts "Updated another 5 talks. Total talks searched: '#{index}'. " +
          "Total listeners deleted: '#{res[:no]}'"
      end
    end
    puts "Kept #{res[:yes]} saved listeners, #{res[:no]} have been deleted."
  end

  desc "Regenerate plain text for descriptions"
  task regenerate_plain_text: :environment do
    fields = {[User] => "about", [Talk, Series, Organization] => "description"}
    items = {}
    puts "Starting to regenerate plain text for:"
    sum = 0
    fields.each do |models, field|
      models.each do |model|
        items[model] ||= model.where("#{field} is not null and #{field} != ''")
        puts "\t#{model}.#{field}: #{items[model].size} items"
        sum += items[model].size
      end
    end
    puts "Total: #{sum} items. This might take a while."
    sum = 0
    fields.each do |models, field|
      models.each do |model|
        puts "Regenerating plain text for #{model}.#{field}..."
        count = 0
        items[model].each do |item|
          item.send("#{field}_as_text=", MD2TEXT.render(item.send(field)))
          item.save
          count += 1
        end
        puts "Done! Regenerated plain text for #{count} instances of #{model}.#{field}."
        sum += count
      end
    end
    puts "Finished task. Regenerated plain text for #{sum} total fields."
  end

  task associate_default_venues: :environment do
    total = User.count
    index = 0
    User.find_each do |user|
      index += 1
      venue = user.venues.order(:id).first
      if venue.nil?
        puts "%s/%s %s %s" % [index, total, user.name, "NO VENUES!"]
      else
        puts "%s/%s %s %s" % [index, total, user.name, venue.name]
        user.default_venue = venue
        user.save!
      end
    end
  end

end
