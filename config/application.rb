require File.expand_path('../boot', __FILE__)

require 'rails/all'

require File.expand_path('../../lib/core_ext', __FILE__)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VoiceRepublic
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W( #{config.root}/app/middlewares
                                 #{config.root}/app/mailers
                                 #{config.root}/app/jobs
                                 #{config.root}/lib )

    config.i18n.enforce_available_locales = true

    # Set Time.zone default to the specified zone and make Active
    # Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone
    # names. Default is UTC.
    config.time_zone = 'Berlin'
    # config.active_record.default_timezone = 'Berlin'

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # configure some test-suite thingies
    config.generators do |g|
      g.test_framework( :rspec,
                        :fixtures => true,
                        :view_specs => false,
                        :helper_specs => false,
                        :routing_specs => false,
                        :controller_specs => true,
                        :request_specs => true )
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.middleware.use 'EnforceRobotsTxt',
                          source: Rails.root.join('public/robots.txt')

    config.middleware.use 'Tts'

    # has to be wrapped in `config.before_initialize` in order to use Settings
    config.before_initialize do
      config.middleware.use 'FayeAuth', secret: Settings.faye.secret_token
    end

    # increases Talk#play_count and redirects to Talk#generate_ephemeral_path!
    config.middleware.use 'MediaTracker'

    config.middleware.use 'Slides'

    config.middleware.use 'Backup'

    config.middleware.use 'IceboxEndpoint'

    config.middleware.use 'StreamboxxEndpoint'

    config.middleware.use 'Rack::Affiliates'

    config.middleware.use 'PhpResponder'

    config.assets.initialize_on_precompile = false

    # http://stackoverflow.com/questions/18294150/how-to-use-fonts-in-rails-4
    config.assets.paths << "#{config.root}/app/assets/fonts"

    # config.assets.precompile += %w( *.js *.png *.jpg *.eot *.woff *.ttf *.svg )
    config.assets.precompile += %w( cljs.js
                                    embed.js
                                    embed.css )

    # Handling exceptions dynamically using middleware.
    # Here a rack middleware app could be configured, instead we are using the
    # Rails app itself
    # http://railscasts.com/episodes/53-handling-exceptions-revised?view=asciicast
    config.exceptions_app = self.routes

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end


# http://stackoverflow.com/questions/6363471
# ActionDispatch::Callbacks.after do
#   # Reload the factories
#   return unless (Rails.env.development? || Rails.env.test?)
#
#   unless FactoryGirl.factories.blank? # first init will load factories, this should only run on subsequent reloads
#     FactoryGirl.factories.clear
#     FactoryGirl.find_definitions
#   end
# end
