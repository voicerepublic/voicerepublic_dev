namespace :stream do

  desc 'merge streams with StreamMerger'
  task :merge, [:talk, :strategy] => :environment do |t, args|
    talk, strategy = args[:talk], args[:strategy]
    raise 'talk not set' if talk.nil?
    base = Settings.rtmp.recordings_path
    path = "#{base}/#{talk}"
    journal = "#{path}.journal"
    unless File.exist?(journal)
      StreamMerger.generate_fake_journal(base, talk)
      puts "Journal not found for talk #{talk}, generated a fake journal."
    end
    StreamMerger.run(path, strategy)
    puts
    puts "Streams merged. Result:"
    puts
    puts "  #{path}"
    puts
  end

end
