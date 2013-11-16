class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_or_guest_user

  before_filter :set_last_request#, :check_rates
  before_filter :set_locale
  around_filter :user_time_zone, :if => :current_user


  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user
  end


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

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    # For example:
    # guest_comments = guest_user.comments.all
    # guest_comments.each do |comment|
      # comment.user_id = current_user.id
      # comment.save!
    # end
  end

  def create_guest_user
    name = "guest_#{Time.now.to_i}#{rand(99)}"
    u = User.create :name => 'guest',
                    :email => "#{name}@example.com",
                    :available => "online",
                    :firstname => 'guest',
                    :lastname => name

    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end


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
    if current_or_guest_user
      current_or_guest_user.update_attribute(:last_request_at, Time.now) if ( current_or_guest_user.last_request_at.nil? ) || ( current_or_guest_user.last_request_at < Time.now - 1.minute )
    end
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
end
