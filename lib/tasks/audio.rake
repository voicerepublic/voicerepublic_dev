namespace :audio do

  desc 'run an audio strategy'
  task :run, [:strategy, :path, :name] => :environment do |t, args|
    strategy = args[:strategy] || 'strategy_missing'
    path = args[:path] || '.'
    name = args[:name] || 'dummy'
    setting = TalkSetting.new(path, name)
    result = nil
    Dir.chdir(setting.path) do
      result = Audio::StrategyRunner.new(setting).run(strategy)
    end
    result = [result] unless result.is_a?(Array)
    result = result.map { |r| [ path, r ] * '/' }
    puts *result
  end

  desc 'lists all available audio strategies'
  task strategies: :environment do
    glob = Rails.root.join('lib/audio/strategy/*.rb')
    files = Dir.glob(glob)
    puts *files.map { |f| File.basename(f, '.rb') }
  end

  # desc 'check all talks for missing formats of given strategy and transcode'
  # task :transcode_missing, [:strategy_name] => :environment do |t, args|
  #   strategy_name = args[:strategy_name]
  #   strategy = strategy_name.classify.constantize
  #   talks = Talk.archived.without_audio_format(strategy::EXTENSION)
  #   count = talks.count
  #   talks.each_with_index do |talk, index|
  #     puts "#{index}/#{count} transcoding talk ##{talk.id} with #{strategy_name}"
  #     talk.transcode!(strategy)
  #   end
  # end

end
