class LandingPageController < ApplicationController
  
  def index
    @venues = Venue.all
    @user = User.new
  end
  
end
