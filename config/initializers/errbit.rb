if Settings.errbit.enabled
  Airbrake.configure do |config|
    config.project_key = Settings.errbit.api_key
    config.project_id = true
    config.host = Settings.errbit.host
    config.environment = Settings.errbit.environment
  end
end
