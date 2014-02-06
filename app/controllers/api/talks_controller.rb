class Api::TalksController < ApplicationController

  before_action :set_talk

  # delegate to a sepcific event or complain
  def update
    event = params[:event] || 'event_missing'
    if respond_to? event
      send params[:event]
      head :ok
    else
      logger.debug output = [ '-'*50,
                              "Unknown Event: '#{event}'",
                              PP.pp(params, "") ] * "\n"
      render :text => output, :status => 422
    end
  end

  protected

  # update the session on talk, publish event via faye for instant update
  def register
    Talk.transaction do
      session = @talk.reload.session || {}
      session[params[:user][:handle]] = params[:user].to_hash
      @talk.update_attribute :session, session
    end
    publish params.to_hash
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
