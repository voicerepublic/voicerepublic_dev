require 'rails_helper'

describe Api::TalksController do

  describe 'unauthenticated' do
    it 'returns an error or redirect' do
      get :index
      expect(response.status).to be(302)
    end
  end

  describe 'authenticated' do
    it 'returns json' do
      user = FactoryGirl.create(:user)
      get :index, user_email: user.email, user_token: user.authentication_token
      expect(response.status).to be(200)
    end
  end

end
