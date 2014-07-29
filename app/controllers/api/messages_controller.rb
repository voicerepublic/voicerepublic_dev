class Api::MessagesController < Api::BaseController

  before_action :authenticate_user!
  before_action :set_talk

  def create
    user = current_user

    # TODO: move into ability class, use cancan
    # TODO: check resulting queries, maybe use eager loading
    good = @talk.venue.user == user
    good = good || @talk.guests.include?(user)
    good = good || @talk.venue.users.include?(user)
    return render text: 'Computer says no', status: 740 unless good

    message = @talk.messages.build(message_params)
    message.user = user
    message.save!

    params[:message].merge! user_id: user.id
    # TODO: This will localise the message for the user sending the message.
    # It will not always correspond to the time.zone of the user reading the
    # messsage. This needs a better solution.
    params[:message].merge! created_at: I18n.l(message.created_at, format: :short)
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

  def message_params
    params.require(:message).permit(:content)
  end
  
end
