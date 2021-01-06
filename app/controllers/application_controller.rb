class ApplicationController < ActionController::Base

  layout 'velvet'

  RSS_GONE = '410 - Sorry, this RSS feed is gone for good.'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_action :set_last_request
  #before_action :set_locale

  around_action :user_time_zone, :if => :current_user
  after_action :set_csrf_cookie_for_ng

  # TODO: We do we not have this in the app, yet?
  #rescue_from CanCan::AccessDenied do |exception|
  #  redirect_to root_url, :alert => exception.message
  #end

  # # TODO move to trickery
  # after_action :log_callback_chain
  # def log_callback_chain
  #   fmt = "  %-14s %-6s %-22s %s"
  #   logger.debug 'Callback chain'
  #   _process_action_callbacks.each do |cb|
  #     logger.debug fmt % [cb.name, cb.kind, cb.klass.name, cb.filter]
  #   end
  # end

  def user_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def after_sign_in_path_for(user)
    return_to = ( request.env['omniauth.origin'] || stored_location ||
                  stored_location_for(user) || session[:series_path] ||
                  user_path(user) )
    logger.debug(">>> RETURNING TO: #{return_to}")
    return_to
  end

  def stored_location
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  before_action :update_sanitized_params, if: :devise_controller?

  # strong parameters for devise
  def update_sanitized_params
    # devise_parameter_sanitizer.for(:sign_up) do |u|
    #   u.permit(UsersController::PERMITTED_ATTRS)
    # end
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname, :accept_terms_of_use, :slug, :email, :avatar, :header, :timezone, :facebook, :twitter, :website, :summary, :about, :password, :password_confirmation, :referrer])

    # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :accept_terms_of_use, :slug, :email, :avatar, :header, :timezone, :facebook, :twitter, :website, :summary, :about, :password, :password_confirmation, :referrer) }
  end

  # === Better Exception Handling ===
  rescue_from CanCan::AccessDenied, with: :forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  # ActionView::Template::Error
  # ActionController::InvalidAuthenticityToken
  # Errno::ENOSPC

  def forbidden
    respond_to do |format|
      format.html do
        @body_classes = %w( error 403 forbidden )
        render layout: 'velvet', status: 403, action: :forbidden
      end
      format.text { render status: 403, text: 'Forbidden!' }
    end
  end

  def not_found
    respond_to do |format|
      format.html do
        @body_classes = %w( error 404 not-found )
        render layout: 'velvet', status: 404, action: :not_found
      end
      format.rss { render status: 410, text: RSS_GONE }
      format.json { render status: 404, text: 'Not found.' }
    end
  end

  def internal_server_error
    @body_classes = %w( error 500 internal-server-error )
    render layout: 'velvet', status: 500, action: :internal_server_error
  end

  private

  # get locale from browser settings
  def extract_locale_from_accept_language_header
    begin
      accept = request.env['HTTP_ACCEPT_LANGUAGE']
      return (accept && accept.scan(/^[a-z]{2}/).first) || 'en'
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
  end

  def set_last_request
    if current_user
      if ( current_user.last_request_at.nil? ) ||
        ( current_user.last_request_at < Time.now - 1.minute )
        current_user.update_attribute(:last_request_at, Time.now)
      end
    end
  end

  #def default_url_options(options={})
  #  logger.debug "default_url_options is passed options: #{options.inspect}\n"
  #  { :locale => I18n.locale }
  #end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

end
