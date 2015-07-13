require 'rails_helper'

describe Api::TalksController do
  before do
    3.times { FactoryGirl.create :talk }
  end

  describe 'unauthenticated' do
    it 'returns an error or redirect' do
      get :index
      expect(response.status).to be(302)
    end
  end

  describe 'authenticated' do
    it 'returns json' do
      user = FactoryGirl.create(:user)
      get :index, user_email: user.email,
        user_token: user.authentication_token
      expect(response.status).to be(200)
      expect(JSON.parse(response.body).length).to be(3)
    end

    describe 'sql injection' do
      it 'allows valid "order" arguments' do
        user = FactoryGirl.create(:user)
        get :index, user_email: user.email, user_token: user.authentication_token,
          order: "created_at", reverse: "true"
        res = JSON.parse response.body
        expect(res.first['id']).to be(3)
      end
      it 'ignores invalid "order" arguments' do
        user = FactoryGirl.create(:user)
        get :index, user_email: user.email, user_token: user.authentication_token,
          order: "i_do_not_belong_here", reverse: "true"
        res = JSON.parse response.body
        expect(res.first['id']).to be(1)
      end
    end

    it 'does not return irrelevant/dangerous information' do
      user = FactoryGirl.create(:user)
      get :index, user_email: user.email, user_token: user.authentication_token
      res = JSON.parse response.body
      expect(res.first['starts_at']).to_not be_nil
      expect(res.first['session']).to be_nil
    end
  end

end
