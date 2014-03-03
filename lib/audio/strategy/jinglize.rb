# Merges the resulting wav with the start and stop jingle.
#
# Prior to this strategy use MoveClean.
#
module Audio
  module Strategy
    class Jinglize < Base

      def input
        "#{name}.wav"
      end

      # checked as a precondition
      def inputs
        [ input ] + jingles
      end

      def backup
        "#{name}-bak.wav"
      end

      def run
        FileUtils.mv(input, backup)
        merge_with_jingles
        outputs
      end

      def outputs
        [ input, backup ]
      end

      def merge_with_jingles_cmd
        start, stop = jingles
        "sox -m #{start} #{backup} #{stop} #{input}"
      end

      def jingles
        # FIXME: expecting rails env
        [ Rails.root.join('app/assets/audio/start_jingle.wav'),
          Rails.root.join('app/assets/audio/stop_jingle.wav') ]
      end

    end
  end
end
