require 'rails_helper'

describe Api::UploadsController do

  before do
    @user = FactoryGirl.create :user, :with_credits
  end

  describe 'Talk#upload via json' do
    it 'returns errors' do
      post :create, { talk: {title: "spec talk"},
                      user_token: @user.authentication_token,
                      user_email: @user.email,
                      format: 'json' }
      res = JSON.parse(response.body)
      expect(res['errors']).to_not be_empty
      expect(response.status).to eq(422)
    end

    it 'returns the slug of the created talk' do
      # Creating a Talk would have the side effect of postprocessing.
      Delayed::Worker.delay_jobs = true

      venue = FactoryGirl.create :venue, user: @user
      talk = FactoryGirl.attributes_for :talk, :with_user_override_uuid
      talk.merge!(venue_id: venue.id)
      post :create, { talk: talk,
                      user_token: @user.authentication_token,
                      user_email: @user.email,
                      format: 'json' }
      res = JSON.parse(response.body)
      expect(res['slug']).to_not be_empty
      expect(response.status).to eq(200)

      Delayed::Worker.delay_jobs = false
    end
  end

end
