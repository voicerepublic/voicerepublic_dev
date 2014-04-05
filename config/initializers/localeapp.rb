# https://github.com/Locale/localeapp/issues/92
if ENV['RAILS_ENV'] == 'production'
  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = '5EzAUJzfRXXHzt5xW5h6hyOIuJ4dy49d9Il3imi4JKZoXV8IlL'
    config.polling_environments = [] # we'll use `localeapp daemon`
    config.sending_environments = [:production]
    config.cache_missing_translations = true
  end
end
