source 'https://rubygems.org'

#gem 'rails', '4.0.2'
#gem 'rails', '4.0.13'
#gem 'rails', '4.1.9'
gem 'rails', '4.2.0'

#gem 'turbolinks'

gem 'rails-i18n'
gem 'pg'
# https://github.com/collectiveidea/delayed_job
gem "daemons"
gem 'delayed_job'
gem 'delayed_job_active_record'

gem 'less-rails', "2.3.2"
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'therubyracer', platforms: :ruby
gem 'uglifier'#, '>= 1.0.3'

# gem 'jbuilder', '~> 2.0'
# gem 'bcrypt', '~> 3.1.7'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'airbrake'
gem 'rails_config'
gem 'foundation-rails'
gem 'jquery-rails'
gem 'devise', '~> 3.4.0'
gem 'simple_token_authentication', github: 'branch14/simple_token_authentication'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'friendly_id'                  # make urls more friendly
gem 'will_paginate'                # pagination-extension to active-record
gem 'dragonfly', '1.0.3'           # used for images
gem 'angularjs-file-upload-rails', '~> 1.1.0'
gem 'acts-as-taggable-on', '3.4.2' # tag-system
gem 'cancan'                       # authorization/privileges
gem 'private_pub'                  # push service
gem 'thin'                         # faster development-server
gem "dynamic_form"                 # form helper for errors
gem 'whenever'
gem 'haml-rails'
gem 'simple_form'
gem 'unicorn'
gem "select2-rails"
gem 'ckeditor_rails'
gem "transitions", require: ["transitions", "active_model/transitions"], github: 'troessner/transitions'
gem 'fidelity', git: 'git@github.com:munen/fidelity.git'
# gem 'fidelity', path: '../fidelity'
gem 'pg_search', github: 'branch14/pg_search'
gem 'jquery-ui-rails'
gem 'browser'
gem 'fog'
gem 'slick_rails'
gem 'mailgun_rails'

group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'
  gem 'spring-commands-rspec'

  # TODO: Upgrading to Rails 4.1 introduces it's own mail preview mechanism:
  #       http://edgeguides.rubyonrails.org/4_1_release_notes.html#action-mailer-previews
  gem 'letter_opener'
  gem 'rspec_junit_formatter', github: 'sj26/rspec_junit_formatter', require: false
  gem 'letter_opener_web', '~> 1.2.0'
  # gem 'rails_view_annotator'
  gem 'annotator'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano',         '~> 3.1.0'
  gem 'capistrano-bundler', '~> 1.1.1'
  gem 'capistrano-rails',   '~> 1.1.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'byebug'
  gem 'disable_assets_logger'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'foreman',                            require: false
  gem 'meta_request'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rspec-retry'
  # TODO: Upgradming to Rails 4.1 introduces a built in mechanism:
  #       http://api.rubyonrails.org/classes/ActiveSupport/Testing/TimeHelpers.html
  gem 'timecop'
  gem 'vcr',                '2.8.0',        require: false
  gem 'webmock',            '~> 1.15.0',    require: false
  gem 'zeus'

  # http://stackoverflow.com/questions/19929373/rubymine-and-running-rspec
  gem 'rspec-core' # needed when running specs on ci
end

group :test do
  gem 'capybara', '2.2.1'
  gem 'ci_reporter'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

  gem 'guard-rspec'
  gem 'launchy'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.7.1'
end

group :production do
  gem 'rack-cache', require: 'rack/cache'
end
