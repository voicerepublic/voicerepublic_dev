class SearchController < ApplicationController
  
  def search
    @klus = Klu.search(params[:query])  
  end

  def match
    
  end
end
