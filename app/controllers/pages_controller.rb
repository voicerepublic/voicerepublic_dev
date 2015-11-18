class PagesController < ApplicationController

  #layout 'velvet'

  def show
    @page = Page.find(params[:id])
  end

end
