Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse
  # proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved
  # to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use
  # Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Set to :debug to see everything in the log.
  config.log_level = :info

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.delivery_method = :mailgun
  config.action_mailer.mailgun_settings = {
    api_key: 'key-6f7dabba8890f6d7d361a1503b8a1d51',
    domain: 'mg.voicerepublic.com'
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # http://markevans.github.io/dragonfly/rails/
  config.action_dispatch.rack_cache = true


  # class BypassableUglifier
  #
  #   # list the assets which should bypass the uglifier here
  #   LIST = %w( venues.js )
  #
  #   attr_accessor :pathname, :result
  #
  #   def initialize(pathname, &result)
  #     self.pathname = pathname
  #     self.result = result
  #   end
  #
  #   def render(context, options)
  #     return result.call if LIST.include?(File.basename(pathname))
  #
  #     Uglifier.new.compile(result.call)
  #   end
  # end
  #
  # config.assets.js_compressor = BypassableUglifier


  # Optionally disable Javascript/CSS compression
  class NoCompression
    def compress(string)
      # do nothing
      string
    end
  end

  if Settings.no_js_compress
    config.assets.compress = true
    config.assets.js_compressor = NoCompression.new
    #config.assets.css_compressor = NoCompression.new
  end


  config.middleware.use 'Raindrops::Middleware' unless Settings.no_raindrops

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
