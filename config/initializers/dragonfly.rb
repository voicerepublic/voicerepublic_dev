require 'dragonfly'
require 'dragonfly/s3_data_store'


Dragonfly::App.register_datastore(:fileors3){ Dragonfly::FileOrS3DataStore }

module Dragonfly
  class FileOrS3DataStore
    def write(content, opts={})
      Dragonfly.app(:s3).store(content.data, meta: content.meta)
    end
    def read(uid)
      attachment = Dragonfly.app(:s3).datastore.read(uid)
      return attachment ||= Dragonfly.app(:file).datastore.read(uid)
    end
    def destroy(uid)
      Dragonfly.app(:s3).datastore.destroy(uid)
      Dragonfly.app(:file).datastore.destroy(uid)
    end
  end
end

# Configure

dragonfly_secret = "b374766651e5f0c4e88c158b5ad298e094ef3a495ac42f17d6aeb6be62cbe1f5"

Dragonfly.app.configure do
  secret dragonfly_secret
  protect_from_dos_attacks true
  url_format "/media/:job/:name"
  url_host Settings.root_url
  datastore :fileors3
end

Dragonfly.app(:file).configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret dragonfly_secret

  url_format "/media/:job/:name"

  url_host Settings.root_url

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

Dragonfly.app(:s3).configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret dragonfly_secret

  url_format "/media/:job/:name"

  url_host Settings.root_url

  datastore :s3,
    bucket_name: Settings.storage.images,
    access_key_id: Settings.fog.storage.aws_access_key_id,
    secret_access_key: Settings.fog.storage.aws_secret_access_key,
    region: 'eu-central-1'
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
