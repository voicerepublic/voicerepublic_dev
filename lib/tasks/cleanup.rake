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
  # TODO: Maybe it's better to implement an additional state machine state
  # 'abandoned'
  desc 'Set abandoned talks(host never showed up) to state postlive'
  task :fix_abandoned_talk_state => :environment do
    Talk.prelive.where("ends_at < ?", DateTime.now).each do |t|
      t.update_attribute :state, :postlive
      t.save!
    end
  end

end
