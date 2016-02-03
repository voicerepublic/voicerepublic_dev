require 'ostruct'
require 'yaml'
require 'trickery/hash/deep_ostruct'

module Services
  module LocalConfig

    def config
      return @config unless @config.nil?

      @config = OpenStruct.new
      return @config unless File.exist?(config_path)

      @config = YAML.load(File.read(config_path)).deep_ostruct
    end

    private

    def config_path
      File.expand_path(File.join(%w(.. .. .. config settings.local.yml)), __FILE__)
    end

  end
end
