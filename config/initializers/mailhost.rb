_host = case Rails.env
        when 'staging'  
          'staging2.kluuu.com'
        when 'production'
          'www.kluuu.com'
        when 'development'
          'localhost'
        when 'test'
          'localhost'
        end

VoiceRepublic::Application.config.action_mailer.default_url_options = { :host => _host }
Rails.application.routes.default_url_options[:host] = _host 
