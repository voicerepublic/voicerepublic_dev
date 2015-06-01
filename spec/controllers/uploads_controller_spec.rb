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

  describe 'Talk#upload' do
    it 'creates a pre-signed S3 URL that will be used in Angular File Upload' do
      get :new
      expect(assigns(:presigned_s3_post_url)).not_to be_nil
      expect(assigns(:presigned_s3_post_url).to_s).to match(/http.*s3.*/)
    end

    describe 'json api' do
      it 'returns errors' do
        post :create, { talk: {title: "spec talk"}, format: 'json' }
        res = JSON.parse(response.body)
        expect(res['errors']).to_not be_empty
        expect(response.status).to eq(422)
      end

      it 'returns the slug of the created talk' do
        Delayed::Worker.delay_jobs = true

        venue = FactoryGirl.create :venue, user: @user
        # allow_any_instance_of(Talk).to receive(:save).and_return(true)
        talk = FactoryGirl.attributes_for :talk, :with_user_override_uuid
        talk.merge!(venue_id: venue.id)
        post :create, { talk: talk, format: 'json' }
        res = JSON.parse(response.body)
        expect(res['slug']).to_not be_empty
        expect(response.status).to eq(200)

        Delayed::Worker.delay_jobs = false
      end
    end
  end

end
