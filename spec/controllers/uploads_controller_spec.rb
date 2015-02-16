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

  describe 'Talk#upload' do
    it 'creates a pre-signed S3 URL that will be used in Angular File Upload' do
      get :new
      assigns(:presigned_s3_post_url).should_not be_nil
      assigns(:presigned_s3_post_url).to_s.should =~ /http.*s3.*/
    end
  end

end
