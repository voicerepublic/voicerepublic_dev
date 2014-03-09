class Api::SocialSharesController < ApplicationController

  skip_before_filter :authenticate_user!

  def create
    @social_share            = SocialShare.new(params[:social_share])
    @social_share.request_ip = request.remote_addr
    @social_share.user_agent = request.user_agent
    @social_share.user_id    = current_or_guest_user.id

    respond_to do |format|
      if @social_share.save
        format.js { render json: { message: I18n.t('.has_been_tracked') } }
      else
        format.js { render json: { message: @social_share.errors } }
      end
    end
  end

  private
  def social_share_params
    params.require(:social_share).permit(:request_ip, :user_agent, :user_id,
                                         :shareable_id, :shareable_type,
                                         :social_network)
  end
end
