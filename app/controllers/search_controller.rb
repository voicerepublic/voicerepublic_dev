class SearchController < ApplicationController

  def search
    @query = params[:query] || params[:landing_page_query]
    @klus = Venue.search(@query)
  end
  # 
  # def match
  #   
  # end
  # 
  # def tagged_with
  #   _klus = Klu.tagged_with(params[:tag])
  #   logger.debug("SearchController#tagged_with - tag: #{params[:tag]} count: #{_klus.count}")
  #   @tag = params[:tag]
  #   @kluuus = []
  #   @no_kluuus = []
  #   _klus.each { |klu| klu.instance_of?(Kluuu) ? @kluuus << klu : @no_kluuus << klu }
  # end
  
end
