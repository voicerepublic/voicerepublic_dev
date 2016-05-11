class Xhr::MessagesController < Xhr::BaseController

  before_action :authenticate_user!
  before_action :set_talk

  def create
    user = current_user

    message = @talk.messages.build(message_params)
    message.user = user
    authorize! :create, message
    message.save!

    head :ok
  end

  private

  def set_talk
    @talk = Talk.find(params[:id])
  end

  # protect_from_forgery for angular ajax requests (overwrite CSRF check)
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def message_params
    params.require(:message).permit(:content)
  end

end
