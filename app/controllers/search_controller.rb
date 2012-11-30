class SearchController < ApplicationController
  
  def search
    @query = params[:query] || params[:landing_page_query]
    @klus = Klu.search(@query)  
  end

  def match
    
  end
  
  def tagged_with
    _klus = Klu.tagged_with(params[:tag])
    @tag = params[:tag]
    @kluuus = []
    @no_kluuus = []
    _klus.each { |klu| klu.instance_of?(Kluuu) ? @kluuus << klu : @no_kluuus << klu }
  end
  
end
