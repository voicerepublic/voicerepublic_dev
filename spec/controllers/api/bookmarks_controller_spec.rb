require 'rails_helper'

describe Api::BookmarksController do

  describe 'unauthenticated' do
    it 'returns an error or redirect' do
      get :index
      expect(response.status).to be(302)
    end
  end

  describe 'authenticated' do

    let(:user) { FactoryGirl.create :user }

    let(:talks) { FactoryGirl.create_list :talk, 3, :archived }

    let(:reminders) { talks.map { |talk| FactoryGirl.create :reminder,
                                                            user: user,
                                                            rememberable: talk } }

    let(:credentials) { { user_email: user.email,
                          user_token: user.authentication_token } }

    before do
      reminders # access reminders to actually have them created (lets are lazy)
    end

    it 'returns json' do
      get :index, credentials
      expect(response.status).to be(200)
      data = JSON.parse(response.body)
      expect(data.length).to be(3)
    end

    describe 'sql injection' do
      it 'allows valid "order" arguments' do
        get :index, credentials.merge(order: "created_at", reverse: "true")
        data = JSON.parse(response.body)
        expect(data.first['id']).to be(3)
      end
      it 'ignores invalid "order" arguments' do
        get :index, credentials.merge(order: "i_do_not_belong_here", reverse: "true")
        data = JSON.parse(response.body)
        expect(data.first['id']).to be(3)
      end
    end

    it 'does not return irrelevant/dangerous information' do
      get :index, credentials
      data = JSON.parse(response.body)
      expect(data.first['title']).to_not be_nil
      expect(data.first['session']).to be_nil
    end
  end

end
