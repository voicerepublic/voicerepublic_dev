# Each strategy defines a method `run`, which usually relies on the
# presence of one or more input files to produce one or more output
# files. If `input` (for a single file) or `inputs` (for a list of
# files) resp. `output` or `outputs` is defined, the presence of these
# files will be checked as a pre- resp. postcondition. If the
# condition is not met an error will be raised and the StrategyRunner
# will skip the strategy.
#
module Audio
  module Strategy
    class Base < Struct.new(:opts)

      include ::CmdRunner

      class << self
        def call(opts)
          path = opts[:path]
          Dir.chdir(path) do
            instance = new(opts)

            precond = inputs.inject(true) { |r, i| r && File.exist?(i) } 
            raise "preconditions not met for #{name} in #{path}" unless precomd

            result = instance.run

            postcond = outputs.inject(true) { |r, i| r && File.exist?(i) }
            raise "potsconditions not met for #{name} in #{path}" unless postcond
          end
          result
        end
      end

      def name
        opts[:name]
      end

      def journal
        opts[:journal]
      end

      def input
        nil
      end

      def inputs
        [ input ].compact
      end

      # returns result
      def run
        raise 'not implemented'
      end

      def output
        nil
      end

      def outputs
        [ output ].compact
      end

    end
  end
end
