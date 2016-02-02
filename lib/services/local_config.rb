require 'yaml'
require 'trickery/hash/deep_ostruct'

module Services
  module LocalConfig

    def config
      @config ||= YAML.load(File.read(config_file)).deep_ostruct
    end

    private

    def config_path
      File.expand_path(File.join(%w(.. .. config settings.local.yml)), __FILE__)
    end

  end
end
