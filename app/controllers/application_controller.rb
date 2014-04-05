class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_filter :set_last_request
  before_filter :check_browser
  #before_filter :set_locale

  around_filter :user_time_zone, :if => :current_user
  after_filter :set_csrf_cookie_for_ng

  # # TODO move to trickery
  # before_filter :log_callback_chain
  # def log_callback_chain
  #   fmt = "  %-14s %-6s %-22s %s"
  #   logger.debug 'Callback chain'
  #   _process_action_callbacks.each do |cb|
  #     logger.debug fmt % [cb.name, cb.kind, cb.klass.name, cb.filter]
  #   end
  # end

  def generate_guest_user?
    true
  end

  # hack to authenticate guest users as well
  def authenticate_user!
    id = session[:guest_user_id]
    if id && @guest_user = User.find(id)
      logger.info "\033[32mAuthenticated guest #{id}\033[0m"
      return @guest_user
    end
    session[:guest_user_id] = nil
    super
  end

  def current_user
    return @guest_user if @guest_user
    session[:guest_user_id] = nil
    user = super
    return user if user
    return nil unless generate_guest_user?
    @guest_user ||= create_guest_user
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def after_sign_in_path_for(user)
    user.update_attribute(:available, 'online') if user.available.nil?
    return_to = ( request.env['omniauth.origin'] || stored_location ||
                  stored_location_for(user) || session[:venue_path] ||
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

  before_filter :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:firstname, :lastname, :accept_terms_of_use,
               :email, :password, :password_confirmation)
    end
  end

  private

  def check_browser
    supported = {
      chrome: 30,
      safari: 7,
      ie: 10,
      firefox: 25
    }
    cur_browser = {
      name: browser.meta.first.to_sym,
      version: browser.version.to_i
    }

    unless cur_browser[:version] >= supported[cur_browser[:name]]
      redirect_to "/upgrade"
    end
  end

  def create_guest_user
    token = SecureRandom.random_number(10000)
    name = ['guest', Time.now.to_i, token ] * '_'
    logger.debug "\033[31mCREATE GUEST USER: #{name}\033[0m"
    user = User.create( email: "#{name}@example.com",
                        firstname: 'guest',
                        lastname: name,
                        guest: true )
    user.save! validate: false
    session[:guest_user_id] = user.id
    user
  end

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

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

end
