class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    @user = current_user
  end
end
