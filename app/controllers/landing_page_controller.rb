class LandingPageController < ApplicationController
  
  def index
    @talks = Talk.featured
    @user = User.new
  end
  
end
