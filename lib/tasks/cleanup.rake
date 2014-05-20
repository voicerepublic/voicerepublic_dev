namespace :cleanup do
  desc 'Delete guest users that are no longer active'
  task :guests => :environment do
    User.where('firstname like ?', '%guest%').
      where('last_request_at < ?', 4.hours.ago).destroy_all
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

  # TODO this should be more generic and move into `trickery`
  # TODO does this deprecate `db:data:validate`?
  desc 'Check validity of talks, series and user profiles'
  task :check_validity => :environment do

    class InvalidModelException < Exception
      def initialize(msg)
        @msg = msg
      end
    end

    errors_count = 0
    error_ids = {
      talks: [],
      series: [],
      users: [],
    }
    ressources = [ [Talk, :talks], [Venue, :series], [User, :users]]

    ressources.each do |model, key|
      model.all.each do |m|
        unless m.valid?
          error_ids[key] << [ "#{m.id.to_i}", m.errors.full_messages ]
          errors_count += 1
        end
      end
    end

    if errors_count > 0
      puts error_ids
      msg = { invalid_models: error_ids, errors_count: errors_count }
      Rails.logger.warn "====\nInvalid models: #{errors_count}."
      Rails.logger.warn msg.to_s + "\n===="
      raise InvalidModelException.new msg
    end
  end

  task fix_blank_descriptions: :environment do
    Talk.where(description: '').each do |talk|
      talk.update_attribute :description, '<i>blank description</i>'
    end
  end

  # TODO this task is to be removed after transition to s3
  task move_to_s3_step1: :environment do
    # fix uris
    update = "uri = concat('lt14-', substring(uri from '[^/]+$'))"
    Talk.update_all(update, "uri LIKE 'lt://2014/%'")
    update = "uri = concat('rp14-', substring(uri from '[^/]+$'))"
    Talk.update_all(update, "uri LIKE 'rp://2014/%'")
    update = "uri = concat('vr-', id)"
    Talk.update_all(update, "uri IS NULL")

    # move log files
    log_path = File.expand_path(Settings.paths.log, Rails.root)
    FileUtils.mkdir_p(log_path, verbose: true)
    archive_path = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    logs = Dir.glob(File.join(archive_path, '*', '*', '*', '*.log'))
    FileUtils.mv(logs, log_path, verbose: true)

    # upload everything to s3
    dir = Storage.directories.create(key: Settings.storage.media)

    files = Talk.archived.inject({}) do |result, talk|
      transitions = talk.all_files.inject({}) do |files, file|
        files.merge file => (talk.uri + '/' + File.basename(file))
      end
      result.merge transitions
    end

    count = files.keys.size
    counter = 0
    files.each do |file, key|
      counter =+ 1
      handle = File.open(file)
      puts "uploading #{counter}/#{count} #{file} to #{key}"
      dir.files.create key: key, body: handle
    end
  end
  
  # TODO this task is to be removed after transition to s3
  task move_to_s3_step2: :environment do
    # delete symlinks
    path = File.expand_path('public/system/audio', Rails.root)
    FileUtils.rm_rf(path, verbose: true)

    # delete archive and archive_raw
    path = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    FileUtils.rm_rf(path, verbose: true)
    path = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    FileUtils.rm_rf(path, verbose: true)
  end
  
end
