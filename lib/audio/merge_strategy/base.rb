require 'date'

module Audio
  module MergeStrategy
    class Base

      class << self
        def call(base)
          new(base).run
        end
      end

      attr_accessor :base, :journal

      def initialize(base)
        self.base = base
        self.journal = parse_journal
      end

      def run
        raise 'not implemented'
      end

      def journal_path
        base + '.journal'
      end

      # the content of the journal file might look like this:
      #
      #     publish asdf-1390839394.flv
      #     publish asdf-1390839657.flv
      #     publish asdf-1390898541.flv
      #     publish asdf-1390898704.flv
      #     record_done asdf-1390839394.flv 1390839394
      #     record_done asdf-1390839657.flv 1390839657
      #     record_done asdf-1390898541.flv 1390898541
      #     record_done asdf-1390898704.flv 1390898704
      #
      # the journal will look like this
      #
      #     {"publish"=>
      #       [["asdf-1390839394.flv"],
      #        ["asdf-1390839657.flv"],
      #        ["asdf-1390898541.flv"],
      #        ["asdf-1390898704.flv"]],
      #       "record_done"=>
      #         [["asdf-1390839394.flv", "1390839394"],
      #          ["asdf-1390839657.flv", "1390839657"],
      #          ["asdf-1390898541.flv", "1390898541"],
      #          ["asdf-1390898704.flv", "1390898704"]]}
      #
      def parse_journal
        raise "Journal not found: #{journal_path}" unless File.exist?(journal_path)
        puts journal = File.read(journal_path)
        Hash.new { |h, k| h[k] = [] }.tap do |hash|
          journal.split("\n").each do |line|
            _, event, path, args = line.match(/^(\w+) ([.\w-]+) ?(.*)$/).to_a
            hash[event] << [path] + args.split if _
          end
        end
      end

      def datetime(str)
        ::DateTime.strptime(str, '%s')
      end

      def exec(method, *args)
        # TODO output or log for debugging
        path = File.dirname(base)
        puts cmd = send(method, *args)
        Dir.chdir(path) { %x[#{cmd}] }
      end

      private

      def method_missing(method, *args)
        cmd_method = "#{method}_cmd"
        return exec(cmd_method, *args) if respond_to?(cmd_method)
        super
      end

    end
  end
end
