require 'spec_helper'

describe Admin::DashboardController do
  
  before do
    %w(admin user).each { |x| Role.create(:name => x)}
    @user = FactoryGirl.create(:admin)
  end

  describe "GET 'index'" do
    it "returns http success" do
      sign_in(@user)   # devise-test-helper-function
      get 'index'
      response.should be_success
    end
  end
  
  describe "GET 'index' as unauthenticated user" do
    it "returns http authentication error" do
      get 'index'
      response.should_not be_success
    end
  end

end
