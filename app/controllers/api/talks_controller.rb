class Api::TalksController < ApplicationController

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
    gfy = event && current_or_guest_user != @talk.user
    return render text: 'Computer says no', status: 740 if gfy

    @method = either.underscore
    @method = :store_state if state && !respond_to?(@method)

    # TODO check for security issue (whitelist methods)
    msg = send @method, msg if respond_to? @method

    publish msg.to_hash
    head :ok
  end

  private

  # genericly stores the state on the authenticated user
  def store_state(msg)
    user_id = current_or_guest_user.id
    Talk.transaction do
      session = @talk.reload.session || {}
      session[user_id][:state] = msg[:state]
      @talk.update_attribute :session, session
    end
    msg[:user] = { id: user_id }
    msg
  end

  # state
  #  * merges user data
  def registering(msg)
    user = current_or_guest_user
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

end
