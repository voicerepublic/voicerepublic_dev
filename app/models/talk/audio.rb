class Talk::Audio < Struct.new(:base)

  def journal
    return @journal unless @journal.nil?
    check_journal!
    journal = File.read(journal_path)
    @journal = Hash.new { |h, k| h[k] = [] }.tap do |hash|
      journal.split("\n").each do |line|
        _, event, path, args = line.match(/^(\w+) ([.\w-]+) ?(.*)$/).to_a
        hash[event] << [path] + args.split if _
      end
    end
  end

  def merge!(strategy=nil)
    check_journal!
    ::Audio::Merger.run(base, strategy)
  end

  def trim!(talk_start, talk_stop)
    file_start = journal['record_done'].first.last.to_i
    ::Audio::Trimmer.run(base, file_start, talk_start, talk_stop)
  end

  def transcode!(strategy=nil, extension=nil)
    strategy ||= 'Audio::TranscodeStrategy::M4a'
    strategy = strategy.constantize if strategy.is_a?(String)
    extension ||= strategy::EXTENSION
    result = ::Audio::Transcoder.run(base, strategy)
    yield extension if block_given?
    result
  end

  private

  def journal_path
    "#{base}.journal"
  end

  # contains implicit knowledge about nameing scheme of files
  def fake_journal(path, name)
    flvs = Dir.glob("#{path}/t#{name}-u*.flv").sort
    result = flvs.map do |flv|
      next nil unless File.size(flv) > 0
      _, basename, timestamp = flv.match(/.*\/(.*?(\d+)\.flv)/).to_a
      ['record_done', basename, timestamp] * ' '
    end
    result.compact * "\n"
  end

  def write_fake_journal!(path, name)
    File.open(journal_path, 'w') do |f|
      f.puts fake_journal(path, name)
    end
  end

  def check_journal!
    unless File.exist?(journal_path)
      name = File.basename(base)
      path = File.dirname(base)
      write_fake_journal!(path, name)
      puts "Journal not found for #{base}, generated a fake journal."
    end
  end

end
