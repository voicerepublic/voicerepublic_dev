class SearchController < ApplicationController
  
  # POST /search
  def create
    redirect_to "/search/#{params[:query]}"
  end
  
  # GET  /search/:query
  def show
    # TODO add pagination
    @results = PgSearch.multisearch(params[:query])
  end
  
end
