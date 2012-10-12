class SearchController < ApplicationController
  
  def search
    @query = params[:query]
    @klus = Klu.search(params[:query])  
  end

  def match
    
  end
end
