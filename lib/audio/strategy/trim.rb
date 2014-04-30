# trims the resulting wav file to talk start and end
#
module Audio
  module Strategy
    class Trim < Base

      def input
        "#{name}.wav"
      end

      def backup
        "#{name}-untrimmed.wav"
      end

      def make_backup_cmd
        "mv #{input} #{backup}"
      end
      
      def run
        make_backup
        trim
        input
      end

      # FIXME only triming the end does not work
      def trim_cmd
        return "sox -V1 #{backup} #{input} trim #{start} =#{stop}" if start > 0

        logfile.puts '# no trim required, resort to simple copy'
        "cp #{backup} #{input}"
      end

      def start
        opts[:talk_start] - file_start
      end
      
      def stop
        opts[:talk_stop] - file_start
      end
      
      def outputs
        [ input, backup ]
      end

    end
  end
end
