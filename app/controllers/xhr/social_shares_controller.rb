class Xhr::SocialSharesController < Xhr::BaseController

  respond_to :json

  def create
    @social_share            = SocialShare.new(social_share_params)
    @social_share.request_ip = request.remote_addr
    @social_share.user_agent = request.user_agent
    @social_share.user_id    = current_user.try(:id)

    return head :ok if @social_share.save

    render status: 406, json: { errors: @social_share.errors }
  end

  private

  def social_share_params
    params.require(:social_share).permit( :shareable_id,
                                          :shareable_type,
                                          :social_network )
  end

end
