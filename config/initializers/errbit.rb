if Settings.errbit.enabled
  Airbrake.configure do |config|
    config.api_key = Settings.errbit.api_key
    config.host    = 'voicerepublic-errbit.herokuapp.com'
    config.port    = 80
    config.secure  = config.port == 443
  end
end
