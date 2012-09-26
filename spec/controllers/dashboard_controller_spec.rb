require 'spec_helper'

describe DashboardController do
  
  before do
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
  
  describe "Get dashboard/contacts" do
    it "returns http success" do
      get 'contacts'
      response.should be_success
    end
    
    it "assigns users @follower and @followed" do
      follower = FactoryGirl.create(:follow, follower: @user)
      followed = FactoryGirl.create(:follow, followed: @user)
      get 'contacts'
      assigns(:followed).should eq([follower])
      assigns(:follower).should eq([followed])
      
    end
  end

  describe "GET dashboard/bookmarks" do
    it "returns http success" do
      get 'bookmarks'
      response.should be_success
    end
    
    it "assigns users bookmarks as @bookmarks" do
      bookmark = FactoryGirl.create(:kluuu_bookmark, user: @user)
      get "bookmarks"
      assigns(:bookmarks).should eq([bookmark])
    end
  end
  
  describe "GET dashboard/matches" do
    it "returns http success" do
      get "matches"
      response.should be_success
    end
    it "assigns matches as @matches"
  end
  describe "GET dashboard/news" do
    it "returns http success" do
      get "news"
      response.should be_success
    end
    it "assigns news as @news"
  end
end
