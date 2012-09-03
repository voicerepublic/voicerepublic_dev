source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'rails-i18n'
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
#gem 'omniauth-twitter'  # ripped cause there is no access to email in twitters oauth-api

gem 'friendly_id'
gem 'will_paginate'
gem 'i18n_data' # delivers languages as key-value hash


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

gem 'thin'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'


# make rspec and cucumber the preferred test-suites
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'faker'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end


