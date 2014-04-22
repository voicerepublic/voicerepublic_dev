class LandingPageController < ApplicationController

  def index
    @talks_featured = Talk.featured.limit(5)
    @talks_live     = Talk.live.limit(5)
    @talks_recent  	= Talk.archived.limit(5)
    @talks_popular  = Talk.popular.limit(5)
    @user           = User.new
  end

end
