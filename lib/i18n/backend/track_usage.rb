module I18n
  module Backend
    class TrackUsage

      def reload!
        path = File.expand_path('../../../../log/translations.log', __FILE__)
        file = File.open(path, 'a')
        file.sync = true
        @logger = Logger.new(file)
        nil
      end

      def translate(*args)
        @logger.info ([Time.now] + args) * ' '
        nil
      end

      def localize(*args)
        nil
      end

    end
  end
end

