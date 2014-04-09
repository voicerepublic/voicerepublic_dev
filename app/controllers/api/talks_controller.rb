class Api::TalksController < Api::BaseController

  before_action :authenticate_user!
  before_action :set_talk


  # single point of entry for updates during live talks
  #
  # delegate to a sepcific message handler or complain
  def update
    msg = params[:msg]
    return render text: 'No `msg` given.', status: 422 unless msg

    state, event = msg[:state], msg[:event]
    either = state || event
    error = 'Neither `state` nor `event` given.'
    return render text: error, status: 422 unless either

    # events may only be send by the host
    gfy = event && current_user != @talk.user
    return render text: 'Computer says no', status: 740 if gfy

    @method = either.underscore
    @method = :store_state if state && !respond_to?(@method)

    # TODO check for security issue (whitelist methods)
    msg = send @method, msg if respond_to? @method

    publish msg.to_hash
    head :ok
  end

  # private

  # genericly stores the state on the authenticated user
  def store_state(msg)
    user = current_user
    Talk.transaction do
      session = @talk.reload.session || {}
      # take defensive action: in rare cases, e.g. for talks
      # migrated from kluuu, we have to make sure this won't fail
      session[user.id] ||= user.details_for(@talk)
      session[user.id][:state] = msg[:state]
      @talk.update_attribute :session, session
    end
    msg[:user] = { id: user.id }
    msg
  end

  # state
  #  * merges user data
  def registering(msg)
    user = current_user
    details = user.details_for(@talk).merge state: msg[:event]
    Talk.transaction do
      session = @talk.reload.session || {}
      session[user.id] = details
      @talk.update_attribute :session, session
    end
    msg[:user] = details
    msg
  end
  alias_method :host_registering, :registering
  alias_method :guest_registering, :registering

  # event
  #  * tigger state transition on talk
  #  * send session around
  #  * publish will trigger participants
  def start_talk(msg)
    @talk.start_talk!
    msg[:session] = @talk.session
    msg
  end

  # event
  #  * trigger state transtion on talk
  def end_talk(msg)
    @talk.end_talk!
    msg
  end


  def set_talk
    @talk = Talk.find(params[:id])
  end

  def publish(message)
    logger.debug "publish to #{@talk.public_channel} #{message.inspect}"
    PrivatePub.publish_to @talk.public_channel, message
  end

  # protect_from_forgery for angular ajax requests (overwrite CSRF check)
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

#  #  _____                 _                 _    _
#  # |__  / ___  _ __    __| |  _ __    __ _ | |_ | |_  ___  _ __  _ __
#  #   / / / _ \| '_ \  / _` | | '_ \  / _` || __|| __|/ _ \| '__|| '_ \
#  #  / /_|  __/| | | || (_| | | |_) || (_| || |_ | |_|  __/| |   | | | |
#  # /____|\___||_| |_| \__,_| | .__/  \__,_| \__| \__|\___||_|   |_| |_|
#  #                           |_|
#  # This code uses the well known Zend pattern. It's robust and well proven in
#  # the industry.
#  # FIXME: This is a dirty hack, Swiss post style. Reason:
#  # When loading a live talk page, a request to "TalksController#show as HTML"
#  # is being made. There, authentication worked and a guest user was
#  # acknowledged. Then a second request was made to
#  # "Api::TalksController#update as HTML", there the guest_user_id was not in
#  # the session anymore (the ajax put request sends a cookie, though).
#  # Therefore, in here a 401 (Unauthorized? Do not understand why not
#  # unauthenticated), was issued with a redirect to /sign_in which yielded all
#  # kinds of problems.
#  def authenticate_user!
#    unless session[:guest_user_id] or session[:user_id]# or current_user or @guest_user
#      @guest_user = User.where(guest: true).last
#      session[:guest_user_id] = @guest_user.id
#    end
#    super
#  end
end
