# http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/

RSpec.configure do |config|

  config.use_transactional_fixtures = false
  config.use_transactional_examples = false # ?

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :truncation
  end

  #config.before(:each) do
  #  DatabaseCleaner.strategy = :transaction
  #end

  #config.before(:each, js: true) do
  #  DatabaseCleaner.strategy = :truncation
  #end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
