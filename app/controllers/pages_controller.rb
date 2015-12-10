class PagesController < ApplicationController

  #layout 'velvet'

  def show
    @page = Page.find(params[:id])

    # call template specific methods to set up instance variables
    send(@page.template) if respond_to?(@page.template)
  end

  private

  def home
    @recent_talks = Talk.recent.limit(4)
    @categories = TagBundle.category.promoted
  end

end
