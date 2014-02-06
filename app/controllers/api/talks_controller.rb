class Api::TalksController < ApplicationController

  before_action :set_talk

  # delegate to a sepcific event or complain
  def update
    event = params[:event]
    event_type = (event && event[:command]) || 'event_type_missing'
    if respond_to? event_type
      send event_type, event
      head :ok
    else
      logger.debug output = [ '-'*50,
                              "Unknown Event: '#{event_type}'",
                              PP.pp(params, "") ] * "\n"
      render :text => output, :status => 422
    end
  end

  protected

  # update the session on talk, publish event via faye for instant update
  def register(event)
    details = nil
    Talk.transaction do
      session = @talk.reload.session || {}
      user_id = event[:user][:id]
      user = User.find(user_id)
      session[user_id] = details = user.details_for(@talk)
      @talk.update_attribute :session, session
    end
    event[:user].merge! details # merge additional info
    publish event.to_hash
  end

  def demote(event)
    # TODO check if current_or_guest_user is the host of the talk
    Talk.transaction do
      session = @talk.reload.session || {}
      session[event[:id]][:role] = 'participant'
      @talk.update_attribute :session, session
    end
    publish event.to_hash
  end

  def promote(event)
    # TODO check if current_or_guest_user is the host of the talk
    Talk.transaction do
      session = @talk.reload.session || {}
      session[event[:id]][:role] = 'guest'
      @talk.update_attribute :session, session
    end
    publish event.to_hash
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
