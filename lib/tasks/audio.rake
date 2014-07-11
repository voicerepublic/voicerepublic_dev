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

  desc 'analyze flv files in current directory'
  # t = Talk.find(1104); [t.started_at.to_i, t.ended_at.to_i] * ','
  task :analyze, [:path, :start, :end] do |t, args|
    path, ts, te = args[:path], args[:start].to_i, args[:end].to_i

    def duration(file)
      line = %x[ avconv -i #{file} 2>&1 | grep Duration ]
      return 0 if line.empty?
      _, h, m, s = line.match(/(\d\d):(\d\d):(\d\d)/).to_a.map { |c| c.to_i }
      (h * 60 + m) * 60 + s
    end

    files = Dir.glob(path+'/*.flv').sort_by { |f| f.match(/t\d+-u\d+-(\d+)\.flv/)[1] }

    file_len = files.map { |f| f.length }.max
    
    files.each do |file|
      dur = duration(file)
      size = File.size(file)
      _, user, t0 = file.match(/t\d+-u(\d+)-(\d+)\.flv/).to_a.map { |c| c.to_i }
      tn = t0 + dur
      flag = nil
      flag = 'X' if dur == 0 and size > 0
      flag ||= '-' if size == 0
      flag ||= '*' unless tn < ts or t0 > te

      puts "%-#{file_len}s % 7d % 7d % 9d % 1s % 9d % 9d" %
           [file, user, dur, size, flag, t0, tn]
    end
    
  end
  
end
