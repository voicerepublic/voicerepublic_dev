require File.expand_path('../boot', __FILE__)

require 'rails/all'

require File.expand_path('../../lib/core_ext', __FILE__)

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module VoiceRepublic
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W( #{config.root}/app/middlewares
                                 #{config.root}/app/jobs
                                 #{config.root}/lib )

    config.i18n.enforce_available_locales = true

    # Set Time.zone default to the specified zone and make Active
    # Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone
    # names. Default is UTC.
    config.time_zone = 'Berlin'

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

    # authenticate access to rtmp against rack middleware
    config.middleware.use 'RtmpAuth'

    # has to be wrapped in `config.before_initialize` in order to use Settings
    config.before_initialize do
      opts = { :log => Settings.rtmp.log_notifications? }
      config.middleware.use 'RtmpNotifications', opts
    end

    # increases Talk#play_count and redirects to Talk#generate_ephemeral_path!
    config.middleware.use 'MediaTracker'

    # attribute_protected/attr_accessible lock down
    config.active_record.whitelist_attributes = true

    config.assets.initialize_on_precompile = false
    
    # http://stackoverflow.com/questions/18294150/how-to-use-fonts-in-rails-4
    config.assets.paths << "#{config.root}/app/assets/fonts"
    # config.assets.precompile += %w( *.js *.png *.jpg *.eot *.woff *.ttf *.svg )
    config.assets.precompile += %w( livepage.js )
  end
end

