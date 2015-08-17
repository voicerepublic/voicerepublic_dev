require 'rails_helper'

describe UploadsController do

  before do
    @user = FactoryGirl.create :user, :with_credits
    # log in user
    allow(request.env['warden']).to receive_messages :authenticate! => @user
    allow(controller).to receive_messages :current_user => @user
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(controller.current_user).to eq(@user)
      expect(response).to be_success
    end
  end

end
