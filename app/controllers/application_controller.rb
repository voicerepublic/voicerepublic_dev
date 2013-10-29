class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_last_request#, :check_rates
  before_filter :set_locale 
  around_filter :user_time_zone, :if => :current_user

  def user_time_zone(&block)
    Time.use_zone(current_user.account.timezone, &block)
  end

  def after_sign_in_path_for(user)
    user.update_attribute(:available, 'online') if user.available.nil?
    if user.is_admin?
      admin_dashboard_index_path
    else
      return_to = ( request.env['omniauth.origin'] || stored_location || 
        stored_location_for(user) || session[:venue_path] || user_path(user) )
    
      logger.debug(">>> RETURNING TO: #{return_to}")
      return_to
    end
  end

  def stored_location
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end
  
  
  
  private
  
  
  def check_rates
    if Money.default_bank.rates.empty?
      Money.default_bank.update_rates
      logger.info("ApplicationController#check_rates - updated rates: #{Money.default_bank.rates}")
    else
      logger.debug("ApplicationController#check_rates - found rates!")
    end
  end
  
  # get locale from browser settings
  def extract_locale_from_accept_language_header
    begin
      return request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : 'en'
    rescue Exception => e
      logger.error("Application#extract_locale_from_accept_language - #{e.message}")
      'en'
    end
  end
  
  def set_locale
    if params[:locale]
      _locale = params[:locale]
    else
      _locale = extract_locale_from_accept_language_header
    end 
    I18n.locale = %w{de en}.include?(_locale) ? _locale : I18n.default_locale
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
  
  def set_last_request
    if current_user 
      current_user.update_attribute(:last_request_at, Time.now) if ( current_user.last_request_at.nil? ) || ( current_user.last_request_at < Time.now - 1.minute )  
    end
  end
  
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
end
