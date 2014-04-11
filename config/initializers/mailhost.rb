VoiceRepublic::Application.config.action_mailer.default_url_options = { :host => Settings.mail_domain }
Rails.application.routes.default_url_options[:host] = Settings.mail_domain
