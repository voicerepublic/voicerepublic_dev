class Api::TalksController < ApplicationController

  before_action :set_talk

  # delegate to a sepcific message handler or complain
  def update
    msg = params[:msg]
    return render text: 'No `msg` given.', status: 422 unless msg

    state, event = msg[:state], msg[:event]
    either = state or event
    return render text: 'Neither `state` nor `event` given.', status: 422 unless either

    method = either.underscore
    if respond_to? method
      send method, msg # TODO check for security issues
      return head :ok
    end

    logger.debug output = [ '-'*50, "Unknown method: '#{method}'",
                            PP.pp(params, "") ] * "\n"
    render :text => output, :status => 422
  end

  protected

  # update the session on talk, publish msg via faye for instant update
  # state
  def registering(msg)
    details = nil
    user_id = msg[:user][:id]
    user = User.find(user_id)
    Talk.transaction do
      session = @talk.reload.session || {}
      session[user_id] = details = user.details_for(@talk).merge state: 'Registering'
      @talk.update_attribute :session, session
    end
    msg[:user].merge! details # merge additional info
    publish msg.to_hash
  end

  # state
  def listening(msg)
    # TODO check if current_user.id is id
    user_id = msg[:user][:id]
    Talk.transaction do
      session = @talk.reload.session || {}
      session[user_id][:state] = 'Listening'
      @talk.update_attribute :session, session
    end
    publish msg.to_hash
  end

  # state
  def waiting_for_promotion(msg)
    # TODO check if current_user.id is id
    user_id = msg[:user][:id]
    Talk.transaction do
      session = @talk.reload.session || {}
      session[user_id][:state] = 'WaitingForPromotion'
      @talk.update_attribute :session, session
    end
    publish msg.to_hash
  end


  # event
  def demotion(msg)
    # TODO check if current_or_guest_user is the host of the talk
    Talk.transaction do
      session = @talk.reload.session || {}
      session[msg[:id]][:role] = 'participant'
      @talk.update_attribute :session, session
    end
    publish msg.to_hash
  end

  # event
  def promotion(msg)
    # TODO check if current_or_guest_user is the host of the talk
    Talk.transaction do
      session = @talk.reload.session || {}
      session[msg[:id]][:role] = 'guest'
      @talk.update_attribute :session, session
    end
    publish msg.to_hash
  end



  def set_talk
    @talk = Talk.find(params[:id])
  end

  def publish(message)
    logger.debug "publish to #{@talk.public_channel} #{message.inspect}"
    PrivatePub.publish_to @talk.public_channel, message
  end

  # protect_from_forgery for angular ajax requests
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end
  
end
