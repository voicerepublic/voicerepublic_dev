class SearchController < ApplicationController

  PER_PAGE = 10

  # POST /search
  def create
    redirect_to "/search/1/" + u(params[:query])
  end

  # GET  /search/1/:query
  def show
    @query = params[:query]
    @results = PgSearch.multisearch(@query).
      paginate(page: params[:page], per_page: PER_PAGE)
  end

  private

  def u(str)
    ERB::Util.url_encode(str)
  end

end
