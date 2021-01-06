source 'https://rubygems.org'

# gem 'rails', '4.2.11.1'
ruby '2.7.1'
# ruby '2.6.3'

gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# gem 'svgeez'

#gem 'turbolinks'

gem 'rails-i18n'
gem 'pg'                           # postgres
gem "daemons"                      # delayed job wants daemons
gem 'delayed_job'
gem 'delayed_job_active_record'

gem 'sass-rails'#, '~> 5.0.2'
gem 'coffee-rails'#, '~> 4.1.0'
gem 'uglifier'#, '>= 1.0.3'

# gem 'jbuilder', '~> 2.0'
# gem 'bcrypt', '~> 3.1.7'
# gem 'sdoc', '~> 0.4.0', group: :doc
gem 'sdoc', group: :doc

gem 'bunny'                        # rmq client
gem 'faker'                        # mock data
gem 'rack-affiliates'
gem 'config'                       # THE rails settings solution
gem 'foundation-rails', '6.6.2.0'
gem 'jquery-rails'
gem 'devise'#, '~> 3.4.0'           # authentication/iam lib for rails
gem 'simple_token_authentication'#, github: 'branch14/simple_token_authentication'
gem 'omniauth-facebook', '4.0.0'
gem 'omniauth-google-oauth2'
gem 'friendly_id'                  # make urls more friendly
gem 'will_paginate'                # pagination-extension to active-record
gem 'dragonfly', '1.0.12'           # used for images
gem 'angularjs-file-upload-rails', '~> 1.1.0'
gem 'acts-as-taggable-on'#, '3.4.2' # tag-system
# gem 'cancan'
gem 'cancancan'                       # authorization/privileges
gem 'thin'                         # faster development-server
gem 'whenever'                     # rubyesque interface to cron jobs
gem 'haml-rails'
gem 'simple_form'
gem 'unicorn'
gem 'selectize-rails'
gem "transitions", github: 'troessner/transitions',
    require: ["transitions", "active_model/transitions"]
#gem 'fidelity', git: 'git@github.com:munen/fidelity.git'
#gem 'fidelity', path: '../fidelity'
gem 'pg_search'
# gem 'jquery-ui-rails'
gem 'jquery-ui-rails', '5.0.5'
gem 'browser'
gem 'fog'
#gem 'fog-aws'
#gem 'fog-local'
gem 'excon'#, '~> 0.45.4'           # http client
gem 'mailgun_rails', '~> 0.9.0'
gem 'activemerchant'
gem 'faye-authentication', github: 'branch14/faye-authentication'
gem 'term-ansicolor'
gem 'redcarpet'                    # markdown parser & renderer
gem 'inifile', require: false
gem 'trickery'
gem 'greensock-rails'
gem "autoprefixer-rails"

group :development do
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
  gem 'capistrano'#,         '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.6.0'
  gem 'capistrano-rails',   '~> 1.5.0'
  gem 'capistrano-rbenv', '~> 2.1.0'
  gem 'meta_request'
  gem 'pry-rails'
  gem 'rspec-rails'#, '3.2.1'
  #gem 'rspec-retry'
  # TODO: Upgradming to Rails 4.1 introduces a built in mechanism:
  #       http://api.rubyonrails.org/classes/ActiveSupport/Testing/TimeHelpers.html
  gem 'vcr',                '2.8.0',        require: false
  gem 'webmock',            '~> 1.15.0',    require: false

  # http://stackoverflow.com/questions/19929373/rubymine-and-running-rspec
  # gem 'rspec-core' # needed when running specs on ci

end

group :test do
  gem 'profmem'#, path: '../../gh/profmem'

  gem 'factory_girl_rails', '~> 4.0'
  gem 'timecop'

  gem 'capybara'#, '2.4.4'
  gem 'ci_reporter'
  gem 'database_cleaner', github: 'bmabey/database_cleaner'

  # BEGIN guard deps
  gem 'guard-rspec', require: false
  gem 'ruby_dep', '1.3.1' # newer versions require ruby 2.2+
  gem 'listen'#, '3.0.8' # newer versions require ruby 2.2+
  # END guard deps


  gem 'launchy'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.7.1'
end

group :test, :development do
  gem 'byebug'
end

group :production do
  gem 'rack-cache', require: 'rack/cache'
  gem 'airbrake', '~> 10.0.3'
end

gem 'mini_racer'
gem 'webpacker'
gem "recaptcha", require: "recaptcha/rails"
gem 'figaro'
gem "hcaptcha"
gem 'fog-backblaze'
gem 'activestorage-backblaze'
gem "aws-sdk-s3", require: false