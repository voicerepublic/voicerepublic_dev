class Xhr::SocialSharesController < Xhr::BaseController

  def create
    @social_share            = SocialShare.new(social_share_params)
    @social_share.request_ip = request.remote_addr
    @social_share.user_agent = request.user_agent
    @social_share.user_id    = current_user.try(:id)

    respond_to do |format|
      if @social_share.save
        format.js { render json: { message: I18n.t('social_share/has_been_tracked') } }
      else
        format.js { render json: { message: @social_share.errors } }
      end
    end
  end

  private

  def social_share_params
    params.require(:social_share).permit( :shareable_id,
                                          :shareable_type,
                                          :social_network )
  end

end
