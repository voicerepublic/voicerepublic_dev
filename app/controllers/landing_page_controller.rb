class LandingPageController < ApplicationController
  
  def index
    @venues = Venue.not_past
    @user = User.new
  end
  
end
