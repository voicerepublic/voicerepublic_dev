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
      response.should be_redirect
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

    it "assigns users klus as @klus, kluu to be matched as @matched_klu and @matching_klus as matching results" # do

  #   klu = FactoryGirl.create(:published_kluuu, user: @user, tag_list: "foo, bar, baz")
  #   FactoryGirl.create_list(:published_kluuu, 3, tag_list: "foo,bar,baz")
  #   ThinkingSphinx::Test.index
  #   assigns(:klus).should eq([klu])
  #
  # end

  end

  describe "GET dashboard/news" do
    it "returns http success" do
      get "news"
      response.should be_success
    end
    it "assigns news as @news"
  end
  
  
  describe "DELETE dashboard/delete_notification" do
    it "destroys the requested notification" do
      notification = FactoryGirl.create(:notification_new_message, :user => @user)
      expect {
        delete :delete_notification, { :notification_id => notification.id }
      }.to change(Notification::Base, :count).by(-1)
    end
  end
  
end
