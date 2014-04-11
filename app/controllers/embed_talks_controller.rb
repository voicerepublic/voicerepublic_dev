class EmbedTalksController < ApplicationController
  after_action :allow_iframe, only: :show
  protect_from_forgery except: :create

  def show
    @talk = Talk.find params[:id]

    respond_to do |format|
      format.html { render layout: 'embed_talk' }
    end
  end

  def create
    @talk = Talk.find params[:embed_talk]

    respond_to do |format|
      format.html { render :show, layout: 'embed_talk' }
    end
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
