class LandingPageController < ApplicationController
  def index
    @kluuus = Kluuu.published.paginate(:page => params[:page], :per_page => 6)
    @no_kluuus = NoKluuu.published.paginate(:page => params[:page], :per_page => 6)
  end
end
