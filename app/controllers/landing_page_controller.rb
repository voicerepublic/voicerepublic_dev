class LandingPageController < ApplicationController
  
  def index
    @talks = Talk.featured
    @talks_live = Talk.live
    @user = User.new
  end
  
end
