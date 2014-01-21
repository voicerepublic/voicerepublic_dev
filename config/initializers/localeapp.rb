if Settings.localeapp.enabled?
  require 'localeapp/rails'

  Localeapp.configure do |config|
    config.api_key = Settings.localeapp.api_key
  end
end
