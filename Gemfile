source 'https://rubygems.org'

gem 'rails', '4.0.2'

gem 'turbolinks'
gem 'protected_attributes' # support legacy 'attr_accessible'
#gem 'localeapp'

gem 'rails-i18n'
gem 'pg'
# https://github.com/collectiveidea/delayed_job
gem "daemons"
gem 'delayed_job'
gem 'delayed_job_active_record'

gem 'less-rails', "2.3.2"
gem 'sass-rails' #,   '~> 3.2.3'
gem 'coffee-rails' #, '~> 3.2.1'
gem 'therubyracer', :platforms => :ruby
gem 'uglifier'#, '>= 1.0.3'

gem 'airbrake'
gem 'rails_config'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'friendly_id'                  # make urls more friendly
gem 'will_paginate'                # pagination-extension to active-record
gem 'will_paginate-bootstrap'      # integrate twitter-bootstrap with will_paginate
gem 'i18n_data'                    # delivers languages as key-value hash
gem 'paperclip'                    # used for images
gem 'dragonfly', '1.0.3'           # used for images
gem 'globalize3'                   # internationalization
gem 'acts-as-taggable-on', '3.0.1' # tag-system
gem 'money-rails'                  # integrates some helper methods and AR-instance-functions...
gem 'eu_central_bank'              # financial exchange rates
gem 'cancan'                       # authorization/privileges
gem 'private_pub'                  # push service
gem 'thin'                         # faster development-server
gem 'thinking-sphinx','2.0.13'     # indexed search
#gem 'mysql2', '0.3.13'            # stupid dependency of thinking-sphinx
gem "dynamic_form"                 # form helper for errors
gem 'whenever', '0.8.4'            # create cron-jobs
gem 'haml-rails'
gem 'simple_form'
gem 'paranoia', '~> 2.0'
gem 'unicorn'
gem "select2-rails"
gem "transitions", :require => ["transitions", "active_model/transitions"]

# make rspec and cucumber the preferred test-suites
group :development, :test, :staging do
  gem 'annotator'
  gem 'sqlite3'
  gem 'capistrano',         '~> 3.1.0'
  gem 'capistrano-rbenv',   '~> 2.0.1'
  gem 'capistrano-bundler', '~> 1.1.1'
  gem 'capistrano-rails',   '~> 1.1.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'rspec-rails'
  gem 'foreman',                            require: false
  # gem 'rails_view_annotator'
  gem 'zeus'
  gem 'pry-rails'
  gem 'debugger'
  gem 'disable_assets_logger'
  gem 'vcr',                '2.8.0',        require: false
  gem 'webmock',            '~> 1.15.0',    require: false
  gem 'timecop'
end

group :test do
  gem 'ci_reporter'
  gem 'capybara'#, '2.0.1'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'simplecov'
end

group :production do
  gem 'rack-cache', require: 'rack/cache'
end
