#spec/support/sphinx_environment.rb
require 'thinking_sphinx/test'
require 'database_cleaner'

def sphinx_environment(*tables, &block)
  obj = self
  begin
    before(:all) do
      obj.use_transactional_fixtures = false
      DatabaseCleaner.strategy = :truncation, {:only => tables}
      ThinkingSphinx::Test.create_indexes_folder
      ThinkingSphinx::Test.start
    end

    before(:each) do
      DatabaseCleaner.start
    end

    after(:each) do
      DatabaseCleaner.clean
    end

    yield
  ensure
    after(:all) do
      ThinkingSphinx::Test.stop
      DatabaseCleaner.strategy = :transaction
      obj.use_transactional_fixtures = true
    end
  end
end
