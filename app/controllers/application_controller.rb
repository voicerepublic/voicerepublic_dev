class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_last_request 
  before_filter :set_locale 
  
  
  def after_sign_in_path_for(resource)
    resource.update_attribute(:available, 'online') if resource.available.nil?
    if resource.is_admin?
      admin_dashboard_index_path
    else
      dashboard_path
    end
  end
  
  private
  
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
