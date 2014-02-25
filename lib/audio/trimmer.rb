class Audio::Trimmer < Struct.new(:base, :file_start, :talk_start, :talk_stop)

  class << self
    def run(*args)
      new(*args).run
    end
  end

  def run
    Dir.chdir(path) { system(cmd) }
    result
  end

  private

  def cmd
    "sox #{input} #{output} trim #{start} =#{stop}"
  end
  
  def path
    File.dirname(base)
  end

  def file
    File.basename(base)
  end

  def input
    "#{file}.wav"
  end

  def output
    "#{file}.trimmed.wav"
  end

  def result
    [ path, output ] * '/'
  end

  def start
    talk_start - file_start
  end

  def stop
    talk_stop - file_start
  end

end
