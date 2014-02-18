namespace :audio do

  desc 'transcode recording of given talk with given strategy'
  task :transcode, [:talk_id, :strategy_name] => :environment do |t, args|
    talk_id, strategy_name = args[:talk_id], args[:strategy_name]
    raise 'talk_id not set' if talk_id.nil?
    path = Talk.find(talk_id).transcode_audio!(strategy_name)
    puts
    puts "Audio transcoded to: #{path}"
    puts
  end

  desc 'check all talks for missing formats of given strategy and transcode'
  task :transcode_missing, [:strategy_name] => :environment do |t, args|
    strategy_name = args[:strategy_name]
    strategy = strategy_name.classify.constantize
    talks = Talk.archived.without_audio_format(strategy::EXTENSION)
    count = talks.count
    talks.each_with_index do |talk, index|
      puts "#{index}/#{count} transcoding talk ##{talk.id} with #{strategy_name}"
      talk.transcode!(strategy)
    end
  end

  desc 'merge recordings of given talk with given strategy'
  task :merge, [:talk_id, :strategy_name] => :environment do |t, args|
    talk_id, strategy_name = args[:talk_id], args[:strategy_name]
    raise 'talk_id not set' if talk_id.nil?
    path = Talk.find(talk_id).merge_audio!(strategy_name)
    puts
    puts "Audio merged to: #{path}"
    puts
  end

end
