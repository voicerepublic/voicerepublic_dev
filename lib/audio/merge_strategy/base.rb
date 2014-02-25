require 'date'

module Audio
  module MergeStrategy
    class Base < Struct.new(:base, :journal)

      class << self
        def call(base, journal)
          new(base, journal).run
        end
      end

      def run
        raise 'not implemented'
      end

      private
      
      def datetime(str)
        ::DateTime.strptime(str, '%s')
      end
      
      def exec(method, *args)
        path = File.dirname(base)
        cmd = send(method, *args)
        # FIXME dependency on Rails.logger
        Rails.logger.info cmd
        Dir.chdir(path) { %x[#{cmd}] }
      end

      def method_missing(method, *args)
        cmd_method = "#{method}_cmd"
        return exec(cmd_method, *args) if respond_to?(cmd_method)
        super
      end

    end
  end
end
