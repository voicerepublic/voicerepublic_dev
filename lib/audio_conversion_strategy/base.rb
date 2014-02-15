require 'date'

module AudioConversionStrategy

  class Base

    class << self
      def call(base)
        new(base).run
      end
    end

    def run
      raise 'not implemented'
    end

    def exec(method, *args)
      # TODO output or log for debugging
      cmd = send(method, *args)
      Dir.chdir(File.dirname(base)) { %x[#{cmd}] }
    end

    private

    def method_missing(method, *args)
      cmd_method = "#{method}_cmd"
      return exec(cmd_method, *args) if respond_to?(cmd_method)
      super
    end

  end

end
