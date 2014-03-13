#require 'simplecov'
#SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'

require 'rspec/retry'

require 'capybara/rspec'
require 'capybara/rails'

require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options = {
    # js errors would otherwise get elevated into an exception
    :js_errors => false,
    :port => 44678
  })
end

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.add_extension(File.expand_path(File.join(Rails.root, 'spec', 'support', 'firefox_extensions', 'firebug-1.12.6.xpi')))

  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.configure do |config|
  config.default_selector = :css

  config.ignore_hidden_elements = true

  config.default_driver    = :rack_test
  config.javascript_driver = :poltergeist
  config.default_wait_time = ENV['CI'] ? 15 : 2
end

# Specific for CircleCI
if ENV['CI']
  # Increase log level on CircleCI to reduce IO
  Rails.logger.level = 4
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.verbose_retry = true # show retry status in spec process

  # Use rspec tags to filter for specific specs
  # Examples
  #   * Run all specs except for chromedriver: zeus rspec --tag ~driver:chrome spec
  #   * Run specs with chromedriver: zeus rspec --tag @driver:chrome spec
  # By default do not run slow specs locally, unless explicitly requested by:
  #  zeus rspec --tag @slow:true spec
  config.filter_run_excluding :slow => :true unless ENV['CI']

  config.filter_run_excluding file_upload: true if ENV['JS_DRIVER'] == 'phantomjs'

  config.color_enabled = true

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # does not work with zeus & specific file
  # config.include FactoryGirl::Syntax::Methods

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # filter only the specs with :focus => true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.include Devise::TestHelpers, :type => :controller
  #config.include Devise::TestHelpers, :type => :feature
  config.include ValidUserRequestHelper, :type => :feature
  #config.include ValidUserRequestHelper, :type => :controller

  # Disable GC and Start Stats
  # disable GC by default
  config.before(:suite) do
    GC.disable
  end

  ## Enable GC
  config.after(:suite) do
    example_counter = 0
    GC.enable
  end

  # Trigger GC after every_nths examples, defaults to 20.
  # Set an appropriate value via config/settings.local.yml
  #
  # (How many specs can your machine ran before it runs out of RAM
  # when GC is turned off?)
  #
  every_nths = Settings.rspec.gc_cycle
  example_counter = 0
  config.after(:each) do
    if example_counter % every_nths == 0
      print 'G'
      GC.enable
      GC.start
      GC.disable
    end
    example_counter += 1
  end

  # database_cleaner is required to allow for feature specs with ajax calls.
  # also transactional fixtures have to be turned off.

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false
  config.use_transactional_examples = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Force asset compilation in a Rack request so it's ready for the Poltergeist
  # request that otherwise times out.
  config.before(:all) do
    if self.respond_to? :visit
      visit '/assets/application.css'
      visit '/assets/application.js'
    end
  end

end

module FactoryGirl
  class << self
    def build_attributes(*args)
      FactoryGirl.build(*args).attributes.delete_if do |k, v|
        ["id", "created_at", "updated_at"].member?(k)
      end
    end
  end
end

# Safe mode forces you to use Timecop with the block syntax since it
# always puts time back the way it was. If you are running in safe
# mode and use Timecop without the block syntax
# Timecop::SafeModeException will be raised to tell the user they are
# not being safe.
# Timecop.safe_mode = true
