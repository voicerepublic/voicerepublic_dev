require 'rails_helper'

describe UploadsController do

  before do
    @user = FactoryGirl.create :user
    # log in user
    allow(request.env['warden']).to receive_messages :authenticate! => @user
    allow(controller).to receive_messages :current_user => @user
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end
  end

  describe 'Talk#upload' do
    it 'creates a pre-signed S3 URL that will be used in Angular File Upload' do
      get :new
      expect(assigns(:presigned_s3_post_url)).not_to be_nil
      expect(assigns(:presigned_s3_post_url).to_s).to match(/http.*s3.*/)
    end
  end

end
