class Api::TalksController < ApplicationController

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

    @method = either.underscore
    @method = :store_state if state && !respond_to?(@method)

    # TODO check for security issue (whitelist methods)
    # TODO check if current_or_guest_user is the host of the talk if event
    if respond_to? @method
      msg = send(@method, msg)
    end

    publish msg.to_hash
    head :ok
  end

  def store_state(msg)
    # TODO check if current_user.id is @user_id (use before_action)
    Talk.transaction do
      session = @talk.reload.session || {}
      session[@user_id][:state] = msg[:state]
      @talk.update_attribute :session, session
    end
    msg
  end

  def registering(msg)
    details = nil
    # TODO check if current_user.id is @user_id (use before_action)
    user = User.find(@user_id)
    Talk.transaction do
      session = @talk.reload.session || {}
      session[@user_id] = details = user.details_for(@talk).merge state: 'Registering'
      @talk.update_attribute :session, session
    end
    msg[:user].merge details # merge additional info
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
