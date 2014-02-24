# The Journal Faker generates missing journals based on implcit
# knowledge about the naming scheme for files written by nginx-rtmp.
class JournalFaker < Struct.new(:base)

  class << self
    def run(base)
      new.check_journal!(base)
    end
  end

  def fake_journal(path, name)
    # FIXME implicit assumption about filenames
    flvs = Dir.glob("#{path}/t#{name}-u*.flv").sort
    result = flvs.map do |flv|
      next nil unless File.size(flv) > 0
      _, basename, timestamp = flv.match(/.*\/(.*?(\d+)\.flv)/).to_a
      ['record_done', basename, timestamp] * ' '
    end
    result.compact * "\n"
  end

  def write_fake_journal!(path, name)
    File.open("#{path}/#{name}.journal", 'w') do |f|
      f.puts fake_journal(path, name)
    end
  end

  def check_journal!(path)
    journal = "#{path}.journal"
    unless File.exist?(journal)
      name = File.basename(path)
      base = File.dirname(path)
      write_fake_journal!(base, name)
      puts "Journal not found for #{path}, generated a fake journal."
    end
  end

end
