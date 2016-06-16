require 'dragonfly'
require 'dragonfly/s3_data_store'


# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "b374766651e5f0c4e88c158b5ad298e094ef3a495ac42f17d6aeb6be62cbe1f5"

  url_format "/media/:job/:name"

  url_host Settings.root_url

  datastore :s3,
    bucket_name: Settings.storage.images,
    access_key_id: Settings.fog.storage.aws_access_key_id,
    secret_access_key: Settings.fog.storage.aws_secret_access_key
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
