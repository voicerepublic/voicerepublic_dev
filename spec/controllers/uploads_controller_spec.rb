require 'spec_helper'

describe UploadsController do

  before do
    @user = FactoryGirl.create :user
    # log in user
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
