# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets. application.js, application.css, and
# all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( application.js
                                                  application.css
                                                  embed.js
                                                  embed.css
                                                  modernizr.js
                                                  dev_webfonts.css
                                                  faye-authentication.js )

if Rails.env.development?
  Rails.application.assets.try(:logger=, Logger.new('/dev/null'))
  Rails::Rack::Logger.class_eval do
    def call_with_quiet_assets(env)
      previous_level = Rails.logger.level
      Rails.logger.level = Logger::ERROR if env['PATH_INFO'] =~ %r{^/assets/}
      call_without_quiet_assets(env)
    ensure
      Rails.logger.level = previous_level
    end
    alias_method_chain :call, :quiet_assets
  end
end
