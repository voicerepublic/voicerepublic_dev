source 'https://rubygems.org'

gem 'rails', '4.0.2'

gem 'turbolinks'
gem 'protected_attributes' # support legacy 'attr_accessible'

gem 'rails-i18n'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less-rails', "2.3.2"
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier'#, '>= 1.0.3'
end

gem 'airbrake'
gem 'rails_config'
gem 'twitter-bootstrap-rails'#,'2.1.4'
gem 'jquery-rails'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'friendly_id'              # make urls more friendly
gem 'will_paginate'            # pagination-extension to active-record
gem 'will_paginate-bootstrap'  # integrate twitter-bootstrap with will_paginate
gem 'i18n_data'                # delivers languages as key-value hash
gem 'paperclip'                # used for images
gem 'awesome_nested_set'       # used for categories
gem 'globalize3'               # internationalization
gem 'acts-as-taggable-on', '3.0.1' # tag-system
gem 'money-rails'              # integrates some helper methods and AR-instance-functions...
gem 'eu_central_bank'          # financial exchange rates
gem 'cancan'                   # authorization/privileges
gem 'private_pub'              # push service
gem 'thin'                     # faster development-server
gem 'capistrano', '2.14.2'     # deployment
gem 'thinking-sphinx','2.0.13' # indexed search
#gem 'thinking-sphinx'
#gem 'mysql2',          '0.3.13' # stupid dependency of thinking-sphinx
gem "dynamic_form"            # form helper for errors
gem 'whenever', '0.8.4'       # create cron-jobs
gem 'haml-rails'
gem 'simple_form'
gem 'paranoia', '~> 2.0'
gem 'unicorn'
gem "select2-rails"

# make rspec and cucumber the preferred test-suites
group :development, :test, :staging do
  gem 'sqlite3'
  gem 'factory_girl_rails', "~> 4.0"
  gem 'faker'
  gem 'rspec-rails'
  gem 'annotator'
  gem 'foreman', :require => false
  gem 'capistrano-rbenv', '1.0.5'
  # gem 'rails_view_annotator'
  gem 'zeus'
  gem 'pry-rails'
  gem 'debugger'
  gem 'disable_assets_logger'
end

group :test do
  gem 'ci_reporter'
  gem 'capybara'#, '2.0.1'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'simplecov'
end
