#Split.configure do |config|
#  config.experiments = YAML.load_file "config/experiments.yml"
#end

Split::Dashboard.use Rack::Auth::Basic do |username, password|
  username == 'kluuu' && password == 'klumich'
end