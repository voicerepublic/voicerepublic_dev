class EmbedTalksController < BaseController

  after_action :allow_iframe, only: :show

  def show
    @talk = Talk.find params[:id]

    respond_to do |format|
      format.html { render layout: 'embed_talk' }
    end
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

end
