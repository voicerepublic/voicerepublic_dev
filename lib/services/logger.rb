require 'logger'

module Services
  module Logger

    def logger
      @logger ||= ::Logger.new(log_path)
      # TODO configer output to include class/service name
    end

    def log_path
      File.expand_path(File.join(%w(.. .. .. log services.log)), __FILE__)
    end

  end
end
