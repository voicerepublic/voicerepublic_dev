class Api::MessagesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_talk

  def create
    user = current_or_guest_user

    # TODO: move into ability class, use cancan
    # TODO: check resulting queries, maybe use eager loading
    good = @talk.venue.user == user
    good = good || @talk.guests.include?(user)
    good = good || @talk.venue.users.include?(user)
    return render text: 'Computer says no', status: 740 unless good

    message = @talk.messages.build(params[:message])
    message.user = user
    message.save!

    params[:message].merge! user_id: user.id
    publish message: params[:message].to_hash
    head :ok
  end

  private

  def set_talk
    @talk = Talk.find(params[:id])
  end

  # TODO: refactor code duplication here and in Api::TalksController
  def publish(message)
    logger.debug "publish to #{@talk.public_channel} #{message.inspect}"
    PrivatePub.publish_to @talk.public_channel, message
  end

  # protect_from_forgery for angular ajax requests (overwrite CSRF check)
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

end
