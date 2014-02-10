class EmbedTalksController < ApplicationController
  after_action :allow_iframe, only: :show

  def show
    @talk = Talk.find params[:id]
    render layout: 'embed_talk'
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
