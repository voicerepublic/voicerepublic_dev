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

    it 'should not show dryrun talks among popular' do
      public_talk = FactoryGirl.create(:talk, :archived)
      private_talk = FactoryGirl.create(:talk, :archived, dryrun: true)
      get :index
      talks_popular = assigns(:talks_popular)
      expect(talks_popular).to include(public_talk)
      expect(talks_popular).not_to include(private_talk)
    end
  end

end
