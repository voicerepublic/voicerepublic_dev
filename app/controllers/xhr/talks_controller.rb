class Xhr::TalksController < Xhr::BaseController

  include OnTheFlyGuestUser
  def generate_guest_user?
    false
  end

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

    # this is critical, so raise an error if it fails
    unless validate_state(state)
      raise "Critical: Failed to set state #{state} " +
            "for user #{current_user.id} " +
            "on talk #{@talk.id} " +
            "with method #{@method}"
    end

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
  #
  # E.g.
  #
  #     {"state"=>"Registering"}
  #
  def registering(msg)
    user = current_user
    details = user.details_for(@talk).merge state: msg[:state]
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
    msg[:talk_state] = @talk.current_state
    msg
  end

  # event
  #  * trigger state transtion on talk
  def end_talk(msg)
    @talk.end_talk!
    msg
  end

  private

  def set_talk
    @talk = Talk.find(params[:id])
  end

  def publish(message)
    logger.debug "publish to #{@talk.public_channel} #{message.inspect}"
    LiveClientMessage.call(@talk.public_channel, message)
  end

  # protect_from_forgery for angular ajax requests (overwrite CSRF check)
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def validate_state(state)
    return true if state.blank?
    state == @talk.reload.session[current_user.id][:state]
  end

end
