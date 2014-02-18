namespace :audio do

  desc 'transcode recording of given talk with given strategy'
  task :transcode, [:talk_id, :strategy_name] => :environment do |t, args|
    talk_id, strategy_name = args[:talk_id], args[:strategy_name]
    raise 'talk_id not set' if talk_id.nil?
    Talk.find(talk_id).transcode!(strategy_name)
    puts
    puts "Audio transcoded. Result:"
    puts
    puts "  #{talk.recording}"
    puts
  end

  desc 'check all talks for missing formats of given strategy and transcode'
  task :transcode_missing, [:strategy_name] => :environment do |t, args|
    strategy_name = args[:strategy_name]
    strategy = strategy_name.classify.constantize
    ext = strategy::EXTENSION
    Talk.archived.without_audio_format(ext).each do |talk|
      puts "Transcoding Talk ##{talk.id} with #{strategy_name}"
      talk.transcode!(strategy)
    end
  end

  desc 'merge recordings of given talk with given strategy'
  task :merge, [:talk_id, :strategy_name] => :environment do |t, args|
    talk_id, strategy_name = args[:talk_id], args[:strategy_name]
    raise 'talk_id not set' if talk_id.nil?

    # TODO move into merger
    base = Settings.rtmp.recordings_path
    path = "#{base}/#{talk_id}"
    journal = "#{path}.journal"
    unless File.exist?(journal)
      StreamMerger.generate_fake_journal(base, talk_id)
      puts "Journal not found for talk ##{talk_id}, generated a fake journal."
    end

    # TODO use Talk.find(talk_id).merge!(strategy_name)
    Audio::Merger.run(path, strategy_name)
    puts
    puts "Audio merged. Result:"
    puts
    puts "  #{path}"
    puts
  end

end
