class Api::TalksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_talk

  # delegate to a sepcific message handler or complain
  def update
    msg = params[:msg]
    return render text: 'No `msg` given.', status: 422 unless msg

    @user_id = msg[:user] && msg[:user][:id]
    return render text: 'No `user id` given.', status: 422 unless @user_id

    state, event = msg[:state], msg[:event]
    either = state || event
    return render text: 'Neither `state` nor `event` given.', status: 422 unless either

    # states may only be send by the user themselves
    gfy = state && current_or_guest_user.id != @user_id.to_i
    # events may only be send by the host
    gfy = gfy || event && current_or_guest_user != @talk.user
    return render text: 'Computer says no', status: 740 if gfy

    @method = either.underscore
    @method = :store_state if state && !respond_to?(@method)

    # TODO check for security issue (whitelist methods)
    msg = send @method, msg if respond_to? @method

    publish msg.to_hash
    head :ok
  end

  # genericly stores the state on the authenticated user
  def store_state(msg)
    Talk.transaction do
      session = @talk.reload.session || {}
      session[@user_id][:state] = msg[:state]
      @talk.update_attribute :session, session
    end
    msg
  end

  def registering(msg)
    details = nil
    user = User.find(@user_id)
    Talk.transaction do
      session = @talk.reload.session || {}
      session[@user_id] = details = user.details_for(@talk).merge state: 'Registering'
      @talk.update_attribute :session, session
    end
    msg[:user].merge! details # merge additional info
    msg
  end

  # event
  #  * tigger state transition on talk
  #  * send session around
  #  * publish will trigger participants
  def start_talk(msg)
    talk.start_talk!
    msg[:session] = talk.session
    msg
  end

  # event
  #  * trigger state transtion on talk
  def end_talk(msg)
    talk.end_talk!
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
