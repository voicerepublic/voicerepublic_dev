require 'rails_helper'

describe RootController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it "returns http success with format rss" do
      get 'index', format: 'rss'
      expect(response).to be_success
    end

    it 'should not show dryrun talks among live' do
      public_talk = FactoryGirl.create(:talk, state: 'live')
      private_talk = FactoryGirl.create(:talk, dryrun: true, state: 'live')
      get :index
      talks_live = assigns(:talks_live)
      expect(talks_live).to include(public_talk)
      expect(talks_live).not_to include(private_talk)
    end
  end

end
