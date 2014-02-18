require File.expand_path('../transcode_strategy', __FILE__)

# use static
#
#   Audio::Transcoder.run('/path/to/recordings')
#   Audio::Transcoder.run('/path/to/recordings', 'MergeStrategy::Experimental')
#
# use instanciation (to run multiple strategies)
#
#   transcoder = Audio::Transcoder.new('/path/to/recordings')
#   transcoder.run
#
# or
#
#   transcoder.run('Audio::TranscodeStrategy::Mp3')
#
module Audio
  class Transcoder < Struct.new(:base)

    class << self

      def run(base, strategy=nil)
        new(base).run(strategy)
      end

    end

    DEFAULT_STRATEGY = ::Audio::TranscodeStrategy::M4a

    def run(strategy=nil)
      if strategy.is_a?(String)
        name = "Audio::TranscodeStrategy::#{strategy.camelize}"
        begin
          strategy = Kernel.const_get(name)
        rescue NameError
          puts "#{name} not found, using default strategy" +
            " #{DEFAULT_STRATEGY} as fallback."
          strategy = nil
        end
      end
      strategy ||= DEFAULT_STRATEGY
      strategy.call(base)
    end

  end
end

# args are path, strategy
Audio::Transcoder.run(*ARGV) if __FILE__==$0
