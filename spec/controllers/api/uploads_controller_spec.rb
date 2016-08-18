require 'rails_helper'
include DjHelpers

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

    describe 'creation of a talk' do
      before do
        @series = FactoryGirl.create :series, user: @user
        @talk = FactoryGirl.attributes_for :talk, :with_user_override_uuid
        @talk.merge!(series_id: @series.id)
      end
      it 'returns the slug of the created talk' do
        # Creating a Talk would have the side effect of postprocessing.
        with_dj_enabled do
          post :create, { talk: @talk,
                          user_token: @user.authentication_token,
                          user_email: @user.email,
                          format: 'json' }
          p res = JSON.parse(response.body)
          expect(res['slug']).to_not be_empty
          expect(response.status).to eq(200)
        end
      end

      it 'fails if the user has no credits left' do
        @user.update_attribute :credits, 0
        with_dj_enabled do
          post :create, { talk: @talk,
                          user_token: @user.authentication_token,
                          user_email: @user.email,
                          format: 'json' }
          res = JSON.parse(response.body)
          expect(response.status).to eq(402)
        end
      end
    end
  end

end
