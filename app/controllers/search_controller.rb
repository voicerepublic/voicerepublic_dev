class SearchController < ApplicationController
  
  def search
    @query = params[:query] || params[:landing_page_query]
    @klus = Klu.search(@query)  
  end

  def match
    
  end
end
