# trims the resulting wav file to talk start and end
#
module Audio
  module Strategy
    class Trim < Base

      def input
        "#{name}.wav"
      end

      def backup
        "#{file}-untrimmed.wav"
      end

      def run
        FileUtils.mv(input, backup)
        trim
        input
      end

      def trim_cmd
        "sox #{backup} #{input} trim #{start} =#{stop}"
      end

      def start
        opts[:talk_start] - opts[:file_start]
      end
      
      def stop
        opts[:talk_stop] - opts[:file_start]
      end
      
      def outputs
        [ input, backup ]
      end

    end
  end
end
