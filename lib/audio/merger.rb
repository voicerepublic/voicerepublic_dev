require File.expand_path('../merge_strategy', __FILE__)

# stream merging logic refactored for testability
#
# use static
#
#   Audio::Merger.run('/path/to/recordings')
#   Audio::Merger.run('/path/to/recordings', 'MergeStrategy::Experimental')
#
# use instanciation (to run multiple strategies)
#
#   merger = Audio::Merger.new('/path/to/recordings')
#   merger.run
#
# or
#
#   merger.run('Audio::MergeStrategy::Experimental')
#
module Audio
  class Merger < Struct.new(:base, :journal)

    class << self
      def run(base, journal, strategy=nil)
        new(base, journal).run(strategy)
      end
    end

    DEFAULT_STRATEGY = ::Audio::MergeStrategy::Kluuu

    def run(strategy=nil)
      if strategy.is_a?(String)
        name = "Audio::MergeStrategy::#{strategy.camelize}"
        begin
          strategy = Kernel.const_get(name)
        rescue NameError
          puts "#{name} not found, using default strategy" +
            " #{DEFAULT_STRATEGY} as fallback."
          strategy = nil
        end
      end
      strategy ||= DEFAULT_STRATEGY
      strategy.call(base, journal)
    end

  end
end

# args are path, strategy
Audio::Merger.run(*ARGV) if __FILE__==$0
