Airbrake.configure do |config|
  config.api_key = '710bf38280e0f96f26a74682519794d5'
  config.host    = 'voicerepublic-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
