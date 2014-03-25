class SearchController < ApplicationController

  PER_PAGE = 10

  # POST /search
  def create
    redirect_to "/search/1/" + u(params[:query] || 'VoiceRepublic')
  end
  
  # GET  /search/1/:query
  def show
    @results = PgSearch.multisearch(params[:query]).
      paginate(page: params[:page], per_page: PER_PAGE)
  end

  private

  def u(str)
    ERB::Util.url_encode(str)
  end
  
end
