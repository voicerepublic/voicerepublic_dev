require 'spec_helper'

describe DashboardController do

  before  do
    #DatabaseCleaner.clean
    @user = FactoryGirl.create(:user)
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
  
  describe "GET 'dasboard/venues'" do
    it "returns http success" do
      get 'venues'
      response.should be_success
    end
    
    # it "assigns users @venues" do
    #   venue = FactoryGirl.create(:venue)
    #   get 'venues'
    #   assigns(:venues).should eq([venue])
    # end
  end
  
end
