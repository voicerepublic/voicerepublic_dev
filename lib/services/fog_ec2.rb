require 'fog'

module Services
  module FogEc2

    def fog
      @fog ||= Fog::Compute.new(config)
    end

    def config
      {
        provider:              'AWS',
        aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      }
    end

  end
end
